@isTest
private class AccountsSelectorTest {

    @isTest
    static void selectByContainingAddress() {
        List<Account> accounts = new List<Account>{
            new Account(
                Name = 'Test1',
                BillingStreet = 'Elm Street 7',
                BillingPostalCode = '1000AA',
                BillingCity = 'Spooktober',
                BillingCountry = 'Netherlands'
            ),
            new Account(Name = 'Test2'),
            new Account(Name = 'Test3')
        };
        insert accounts;

        List<Account> selectedAccountsWithAddress = AccountsSelector.newInstance()
            .selectByContainingAddress(2, 'Name', true);
        System.assertEquals(1, selectedAccountsWithAddress.size());

        List<Account> selectedAccountsWithoutAddress = AccountsSelector.newInstance()
            .selectByContainingAddress(2, 'Name', false);
        System.assertEquals(2, selectedAccountsWithoutAddress.size());
        System.assertEquals('Test3', selectedAccountsWithoutAddress[0].Name);
    }
}