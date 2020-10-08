@isTest
private class CompanyAddressManagerControllerTest {
    private static final Integer RECORD_LIMIT = 3;

    @isTest
    static void getNLastModifiedAccountsWithAddress() {
        GenericMock mock = new GenericMock();
        mock.returns.put('selectByContainingAddress', new Accounts(new List<Account>()));
        AccountsSelector.instance = (AccountsSelector) Test.createStub(AccountsSelector.class, mock);

        CompanyAddressManagerController.getNLastModifiedAccountsWithAddress(RECORD_LIMIT);

        System.assertEquals(1, mock.callCount.get('selectByContainingAddress'));
        System.assertEquals(RECORD_LIMIT, mock.args.get('selectByContainingAddress')[0]);
        System.assertEquals('LastModifiedDate', mock.args.get('selectByContainingAddress')[1]);
        System.assertEquals(true, mock.args.get('selectByContainingAddress')[2]);
    }

    @isTest
    static void getNLastCreatedAccountsWithoutAddress() {
        GenericMock mock = new GenericMock();
        mock.returns.put('selectByContainingAddress', new Accounts(new List<Account>()));
        AccountsSelector.instance = (AccountsSelector) Test.createStub(AccountsSelector.class, mock);

        CompanyAddressManagerController.getNLastCreatedAccountsWithoutAddress(RECORD_LIMIT);

        System.assertEquals(1, mock.callCount.get('selectByContainingAddress'));
        System.assertEquals(RECORD_LIMIT, mock.args.get('selectByContainingAddress')[0]);
        System.assertEquals('CreatedDate', mock.args.get('selectByContainingAddress')[1]);
        System.assertEquals(false, mock.args.get('selectByContainingAddress')[2]);
    }

        @isTest
        static void searchAddressForAccount() {
            Id fakeId = fflib_IDGenerator.generate(Account.getSObjectType());
            GenericMock mock = new GenericMock();
            mock.returns.put('placeSearch', null);
            mock.returns.put('applyAddress', null);
            GooglePlacesService.instance = (GooglePlacesService) Test.createStub(GooglePlacesService.class, mock);
            // Accounts = (Accounts) Test.createStub(Accounts.class, mock);

            CompanyAddressManagerController.searchAddressForAccount(fakeId, 'Sierra Entertainment');

        }
}
