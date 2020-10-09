public interface IAccountsSelector extends fflib_ISObjectSelector {
    List<Account> selectByContainingAddress(Integer recordLimit, String orderByField, Boolean containingAddress);
}