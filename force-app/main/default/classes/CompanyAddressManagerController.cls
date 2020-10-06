public with sharing class CompanyAddressManagerController {

    @AuraEnabled
    public static List<Account> getNLastModifiedAccountsWithAddress(Integer recordLimit) {
        return AccountsService.getInstance().getNLastModifiedAccountsWithAddress(recordLimit).records;
    }

    @AuraEnabled
    public static List<Account> getNLastCreatedAccountsWithoutAddress(Integer recordLimit) {
        return AccountsService.getInstance().getNLastCreatedAccountsWithoutAddress(recordLimit).records;
    }
}
