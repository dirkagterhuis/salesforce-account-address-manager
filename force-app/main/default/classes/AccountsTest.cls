@isTest
private class AccountsTest {

    @isTest
    static void applyAddress() {
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.NewInstance();
        Account acc = new Account(Name = 'Freddy Kreuger Productions');
        insert acc;
        IAccounts accounts = Accounts.newInstance(new List<Account>{acc});
        Accounts.ApplyAddressCommand command = new Accounts.ApplyAddressCommand();
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
        Accounts.newInstance(new List<Account>{acc}).putIfNotBlank(acc, 'Name', 'I\'ve been put');
        System.assertEquals(
            'I\'ve been put',
            acc.Name
        );
    }
}