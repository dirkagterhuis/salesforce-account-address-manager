public with sharing class CompanyAddressManagerController {

    @AuraEnabled
    public static List<Account> getNLastModifiedAccountsWithAddress(Integer recordLimit) {
        return AccountsSelector.getInstance().selectByContainingAddress(recordLimit, 'LastModifiedDate', true).records;
    }

    @AuraEnabled
    public static List<Account> getNLastCreatedAccountsWithoutAddress(Integer recordLimit) {
        return AccountsSelector.getInstance().selectByContainingAddress(recordLimit, 'CreatedDate', false).records;
    }
}