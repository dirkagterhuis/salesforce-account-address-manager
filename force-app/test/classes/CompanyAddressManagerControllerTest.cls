@isTest
private class CompanyAddressManagerControllerTest {
    private static final Integer RECORD_LIMIT = 3;

    @isTest
    static void getNLastModifiedAccountsWithAddress() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        AccountsSelector selectorMock = (AccountsSelector) mocks.mock(AccountsSelector.class);

        mocks.startStubbing();
        mocks.when(selectorMock.SObjectType()).thenReturn(Account.SObjectType);
        mocks.when(selectorMock.selectByContainingAddress(RECORD_LIMIT, 'LastModifiedDate', true)).thenReturn(new List<Account>());
        mocks.stopStubbing();
        Application.Selector.setMock(selectorMock);

        CompanyAddressManagerController.getNLastModifiedAccountsWithAddress(RECORD_LIMIT);

        ((AccountsSelector) mocks.verify(selectorMock)).selectByContainingAddress(RECORD_LIMIT, 'LastModifiedDate', true);
    }

    @isTest
    static void getNLastCreatedAccountsWithoutAddress() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        AccountsSelector selectorMock = (AccountsSelector) mocks.mock(AccountsSelector.class);

        mocks.startStubbing();
        mocks.when(selectorMock.SObjectType()).thenReturn(Account.SObjectType);
        mocks.when(selectorMock.selectByContainingAddress(RECORD_LIMIT, 'CreatedDate', false)).thenReturn(new List<Account>());
        mocks.stopStubbing();
        Application.Selector.setMock(selectorMock);

        CompanyAddressManagerController.getNLastCreatedAccountsWithoutAddress(RECORD_LIMIT);

        ((AccountsSelector) mocks.verify(selectorMock)).selectByContainingAddress(RECORD_LIMIT, 'CreatedDate', false);
    }

    @isTest
    static void searchAddressForAccount_success() {
        Id fakeId = fflib_IDGenerator.generate(Account.getSObjectType());

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_SObjectUnitOfWork uowMock = (fflib_SObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        GooglePlacesService serviceMock = (GooglePlacesService) mocks.mock(GooglePlacesService.class);
        Accounts domainMock = (Accounts) mocks.mock(Accounts.class);

        GooglePlacesService.RetrievedGooglePlace serviceResponse = new GooglePlacesService.RetrievedGooglePlace();
        serviceResponse.status = 'OK';
        serviceResponse.street = 'Twijnstraat 47';
        serviceResponse.postalCode = '3566UI';
        serviceResponse.city = 'Utrecht';
        serviceResponse.country = 'Netherlands';
        Accounts.ApplyAddressCommand command = new Accounts.ApplyAddressCommand();
        command.billingStreet = serviceResponse.street;
        command.billingPostalCode = serviceResponse.postalCode;
        command.billingCity = serviceResponse.city;
        command.billingCountry = serviceResponse.country;

        mocks.startStubbing();
        mocks.when(serviceMock.placeSearch('Sierra Entertainment')).thenReturn(serviceResponse);
        mocks.when(domainMock.SObjectType()).thenReturn(Account.SObjectType);
        ((IAccounts) mocks.doAnswer(new ApplyAddressAnswer(), domainMock)).applyAddress(command, uowMock);
        mocks.stopStubbing();

        Application.Domain.setMock(domainMock);
        Application.UnitOfWork.setMock(uowMock);
        Application.Service.setMock(IGooglePlacesService.class, serviceMock);

        String response = CompanyAddressManagerController.searchAddressForAccount(fakeId, 'Sierra Entertainment');

        ((GooglePlacesService) mocks.verify(serviceMock)).placeSearch('Sierra Entertainment');
        //((Accounts) mocks.verify(domainMock)).applyAddress(command, uowMock);
        System.assertEquals('Success', response);
    }

    @isTest
    static void searchAddressForAccount_noResults() {
        Id fakeId = fflib_IDGenerator.generate(Account.getSObjectType());

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_SObjectUnitOfWork uowMock = (fflib_SObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        GooglePlacesService serviceMock = (GooglePlacesService) mocks.mock(GooglePlacesService.class);
        Accounts domainMock = (Accounts) mocks.mock(Accounts.class);

        GooglePlacesService.RetrievedGooglePlace serviceResponse = new GooglePlacesService.RetrievedGooglePlace();
        serviceResponse.status = 'ZERO_RESULTS';
        Accounts.ApplyAddressCommand command = new Accounts.ApplyAddressCommand();

        mocks.startStubbing();
        mocks.when(serviceMock.placeSearch('Sierra Entertainment')).thenReturn(serviceResponse);
        mocks.when(domainMock.SObjectType()).thenReturn(Account.SObjectType);
        ((IAccounts) mocks.doAnswer(new ApplyAddressAnswer(), domainMock)).applyAddress(command, uowMock);
        mocks.stopStubbing();

        Application.Domain.setMock(domainMock);
        Application.UnitOfWork.setMock(uowMock);
        Application.Service.setMock(IGooglePlacesService.class, serviceMock);

        String response = CompanyAddressManagerController.searchAddressForAccount(fakeId, 'Sierra Entertainment');

        ((GooglePlacesService) mocks.verify(serviceMock)).placeSearch('Sierra Entertainment');
        //((Accounts) mocks.verify(domainMock)).applyAddress(command, uowMock);
        System.assertEquals('No address has been found', response);
    }

    public class ApplyAddressAnswer implements fflib_Answer {
        public ApplyAddressAnswer() {}
        public Object answer(fflib_InvocationOnMock invocation) {
            return null;
        }
    }
}
