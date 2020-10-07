public class AccountsSelector extends fflib_SObjectSelector {
    @testVisible
    private static AccountsSelector instance;

    public static AccountsSelector getInstance() {
        if (instance == null) {
            instance = new AccountsSelector();
        }
        return instance;
    }

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

    public Accounts selectByContainingAddress(Integer recordLimit, String orderByField, Boolean containingAddress) {
        String condition = containingAddress
            ? 'BillingStreet != null AND BillingPostalCode != null AND BillingCity != null AND BillingCountry != null'
            : '(BillingStreet = null OR BillingPostalCode = null OR BillingCity = null OR BillingCountry = null) AND AddressCheckedWithGooglePlaceAPI__c = false';
        return new Accounts(
            (List<Account>) Database.query(
                newQueryFactory()
                .setCondition(condition)
                .setLimit(recordLimit)
                .setOrdering(orderByField, fflib_QueryFactory.SortOrder.DESCENDING, true)
                .toSOQL()
            )
        );
    }
}