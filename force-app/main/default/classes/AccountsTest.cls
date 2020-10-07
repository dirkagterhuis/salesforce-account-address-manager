@isTest
private class AccountsTest {

    @isTest
    static void construct() {
        List<Account> accounts = new List<Account>{
            new Account(
                Name = 'Test'
            )
        };
        System.assertEquals(
            accounts,
            new Accounts(accounts).records
        );
    }
}
