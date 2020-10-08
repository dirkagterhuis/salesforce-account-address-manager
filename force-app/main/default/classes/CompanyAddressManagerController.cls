public with sharing class CompanyAddressManagerController {

    @AuraEnabled
    public static List<Account> getNLastModifiedAccountsWithAddress(Integer recordLimit) {
        return AccountsSelector.getInstance().selectByContainingAddress(recordLimit, 'LastModifiedDate', true).records;
    }

    @AuraEnabled
    public static List<Account> getNLastCreatedAccountsWithoutAddress(Integer recordLimit) {
        return AccountsSelector.getInstance().selectByContainingAddress(recordLimit, 'CreatedDate', false).records;
    }

    @AuraEnabled
    public static String searchAddressForAccount(Id recordId, String accountName) {
        GooglePlacesService.RetrievedGooglePlace response;
        try {
            response = GooglePlacesService.getInstance().placeSearch(accountName);
        } catch (Exception e) {
            throw new CompanyAddressManagerControllerException(
                'Something went wrong in retrieving the address results from Google.' + e.getMessage() + e.getStackTraceString());
        }

        if (response.status != 'OK' && response.status != 'ZERO_RESULTS') {
            throw new CompanyAddressManagerControllerException(
                'Something went wrong in retrieving the address results from Google. The response is:' + response
            );
        }

        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new List<SObjectType> {Account.SObjectType});
        Accounts accounts = makeAccounts(recordId);

        try {
                accounts.applyAddress(convertGoogleResponseToUpdateAddressCommand(response), uow);
        } catch (Exception e) {
            throw new CompanyAddressManagerControllerException(
                'Something went wrong in updating the record in Salesforce. Response from Google: +' + response
            );
        }
        return response.status == 'OK' ? 'Success' : 'No address has been found';
    }

    private static Accounts makeAccounts(Id recordId) {
        return new Accounts(
            new List<Account>{
                new Account(
                    Id = recordId,
                    AddressCheckedWithGooglePlaceAPI__c = true
                )
            }
        );
    }

    private static Accounts.applyAddressCommand convertGoogleResponseToUpdateAddressCommand(GooglePlacesService.RetrievedGooglePlace retrievedGooglePlace) {
        Accounts.applyAddressCommand command = new Accounts.applyAddressCommand();
        if (retrievedGooglePlace.status == 'OK') {
            command.billingStreet = retrievedGooglePlace.street;
            command.billingPostalCode = retrievedGooglePlace.postalCode;
            command.billingCity = retrievedGooglePlace.city;
            command.billingCountry = retrievedGooglePlace.country;
        }
        return command;
    }

    public class CompanyAddressManagerControllerException extends Exception {}
}