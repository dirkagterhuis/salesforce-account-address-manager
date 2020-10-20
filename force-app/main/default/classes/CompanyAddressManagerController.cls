public with sharing class CompanyAddressManagerController {

    @testVisible
    private static fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

    @AuraEnabled
    public static List<Account> getNLastModifiedAccountsWithAddress(Integer recordLimit) {
        return AccountsSelector.newInstance().selectByContainingAddress(recordLimit, 'LastModifiedDate', true);
    }

    @AuraEnabled
    public static List<Account> getNLastCreatedAccountsWithoutAddress(Integer recordLimit) {
        return AccountsSelector.newInstance().selectByContainingAddress(recordLimit, 'CreatedDate', false);
    }

    @AuraEnabled
    public static String searchAddressForAccount(Id recordId, String accountName) {
        GooglePlacesService.RetrievedGooglePlace response;
        try {
            response = GooglePlacesService.newInstance().placeSearch(accountName);
        } catch (Exception e) {
            throw new CompanyAddressManagerControllerException(
                'Something went wrong in retrieving the address results from Google.' + e.getMessage() + e.getStackTraceString()
            );
        }

        if (response.status != 'OK' && response.status != 'ZERO_RESULTS') {
            throw new CompanyAddressManagerControllerException(
                'Something went wrong in retrieving the address results from Google. The response is:' + response
            );
        }

        IAccounts accounts = makeAccounts(recordId);

        try {
            accounts.applyAddress(convertGoogleResponseToUpdateAddressCommand(response), uow);
        } catch (Exception e) {
            throw new CompanyAddressManagerControllerException(
                'Something went wrong in updating the record in Salesforce. Response from Google: +' + response
            );
        }
        return response.status == 'OK' ? 'Success' : 'No address has been found';
    }

    private static IAccounts makeAccounts(Id recordId) {
        return Accounts.newInstance(
            new List<Account>{
                new Account(
                    Id = recordId,
                    AddressCheckedWithGooglePlaceAPI__c = true
                )
            }
        );
    }

    @testVisible
    private static Accounts.ApplyAddressCommand convertGoogleResponseToUpdateAddressCommand(GooglePlacesService.RetrievedGooglePlace retrievedGooglePlace) {
        Accounts.ApplyAddressCommand command = new Accounts.ApplyAddressCommand();
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