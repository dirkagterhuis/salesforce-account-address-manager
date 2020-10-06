public inherited sharing class AccountsService {

    @testVisible
    private static AccountsService instance;

    public static AccountsService getInstance() {
        if (instance == null) {
            instance = new AccountsService();
        }
        return instance;
    }

    public Accounts getNLastModifiedAccountsWithAddress(Integer recordLimit) {
        return new Accounts(
            new AccountsSelector().selectWithAddressWithLimitAndOrderByDesc(recordLimit, 'LastModifiedDate')
        );
    }

    public Accounts getNLastCreatedAccountsWithoutAddress(Integer recordLimit) {
        return new Accounts(
            new AccountsSelector().selectWithoutAddressWithLimitAndOrderByDesc(recordLimit, 'CreatedDate')
        );
    }
}