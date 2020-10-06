public class AccountsSelector extends fflib_SObjectSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Account.Name,
            Account.BillingAddress,
            Account.BillingStreet,
            Account.BillingPostalCode,
            Account.BillingCity,
            Account.BillingCountry,
            Account.Phone,
            Account.AddressCheckedWithGooglePlaceAPI__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Account.sObjectType;
    }

    public List<Account> selectWithAddressWithLimitAndOrderByDesc(Integer recordLimit, String orderByField) {
        return (List<Account>) Database.query(
            newQueryFactory()
            .setCondition('BillingStreet != null AND BillingPostalCode != null AND BillingCity != null AND BillingCountry != null')
            .setLimit(recordLimit)
            .setOrdering(orderByField, fflib_QueryFactory.SortOrder.DESCENDING, true)
            .toSOQL()
        );
    }

    public List<Account> selectWithoutAddressWithLimitAndOrderByDesc(Integer recordLimit, String orderByField) {
        return (List<Account>) Database.query(
            newQueryFactory()
            .setCondition('BillingStreet = null OR BillingPostalCode = null OR BillingCity = null OR BillingCountry = null')
            .setLimit(recordLimit)
            .setOrdering(orderByField, fflib_QueryFactory.SortOrder.DESCENDING, true)
            .toSOQL()
        );
    }
}