public interface IAccounts extends fflib_ISObjectDomain {
    void applyAddress(Accounts.ApplyAddressCommand command, fflib_ISObjectUnitOfWork uow);
    void putIfNotBlank(Account account, String fieldName, String value);
}