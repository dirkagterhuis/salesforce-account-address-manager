public inherited sharing class Accounts extends fflib_SObjectDomain {
    public Accounts(List<Account> sObjectList) {
        super(sObjectList);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Accounts(sObjectList);
        }
    }

    public void applyAddress(applyAddressCommand command, fflib_SObjectUnitOfWork uow) {
        for (Account account : (List<Account>) records) {
            putIfNotBlank(account, 'BillingStreet', command.billingStreet);
            putIfNotBlank(account, 'BillingPostalCode', command.billingPostalCode);
            putIfNotBlank(account, 'BillingCity', command.billingCity);
            putIfNotBlank(account, 'BillingCountry', command.billingCountry);
            uow.registerDirty(account);
        }
        uow.commitWork();
    }

    @testVisible
    private void putIfNotBlank(Account account, String fieldName, String value) {
        if (String.isNotBlank(value)) account.put(fieldName, value);
    }

    public class applyAddressCommand {
        public String billingStreet;
        public String billingPostalCode;
        public String billingCity;
        public String billingCountry;
    }

}