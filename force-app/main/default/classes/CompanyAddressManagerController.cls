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
        String ret;
        GooglePlacesService.GooglePlacesResponse response;
        try {
            response = GooglePlacesService.getInstance().placeSearch(accountName);
        } catch (Exception e) {
            throw new CompanyAddressManagerControllerException(e.getMessage() + e.getStackTraceString());
        }

        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new List<SObjectType> {Account.SObjectType});
        Account accountToUpdate = new Account(Id = recordId, AddressCheckedWithGooglePlaceAPI__c = true);
        uow.registerDirty(accountToUpdate);

        switch on response.status {
            when 'OK' {
                try {
                    accountToUpdate = applyGoogleResponse(accountToUpdate, response.candidates[0].formatted_address);
                    ret = 'Success';
                } catch (Exception e) {
                    throw new CompanyAddressManagerControllerException(
                        'Something went wrong in translating the Google result to a Dutch address format. ' +
                        'The response was: ' + response.candidates
                    );
                }
            }
            when 'ZERO_RESULTS' {
                ret = 'No address has been found';
            }
            when else {
                throw new CompanyAddressManagerControllerException(
                    'Something went wrong in retrieving the address results from Google. The response is:' +
                    response
                );
            }
        }

        uow.commitWork();
        return ret;
    }

    @testVisible
    private static Account applyGoogleResponse(Account acc, String formattedAddress) {
        // example: Twijnstraat 3, 3511 ZG Utrecht, Netherlands"
        List<String> addressfields = formattedAddress.split(',');
        acc.BillingStreet = addressfields[0];
        acc.BillingPostalCode = addressfields[1].left(8).trim();
        acc.BillingCity = addressfields[1].substring(8, addressfields[1].length()).trim();
        acc.BillingCountry = addressfields[2];
        return acc;
    }

    public class CompanyAddressManagerControllerException extends Exception {}
}