@isTest
private class AccountsTest {

    @isTest
    static void construct() {
        List<Account> accountsAsSObjects = new List<Account>{
            new Account(
                Name = 'Test'
            )
        };
        System.assertEquals(
            accountsAsSObjects,
            new Accounts(accountsAsSObjects).records
        );
    }

    @isTest
    static void applyAddress() {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new List<SObjectType> {Account.SObjectType});
        Account acc = new Account(Name = 'Freddy Kreuger Productions');
        insert acc;
        Accounts accounts = new Accounts(new List<Account>{acc});
        Accounts.applyAddressCommand command = new Accounts.applyAddressCommand();
        command.billingStreet = 'Elm Street 7';
        command.billingPostalCode = '1000AA';
        command.billingCity = 'Amsterdam';
        command.billingCountry = 'The Netherlands';

        accounts.applyAddress(command, uow);

        Account result = [SELECT BillingStreet, BillingPostalCode, BillingCity, BillingCountry FROM Account LIMIT 1];
        System.assertEquals('Elm Street 7', result.BillingStreet);
        System.assertEquals('1000AA', result.BillingPostalCode);
        System.assertEquals('Amsterdam', result.BillingCity);
        System.assertEquals('The Netherlands', result.BillingCountry);
    }

    @isTest
    static void putIfNotBlank() {
        Account acc = new Account();
        new Accounts(new List<Account>{acc}).putIfNotBlank(acc, 'Name', 'I\'ve been put');
        System.assertEquals(
            'I\'ve been put',
            acc.Name
        );
    }
}
