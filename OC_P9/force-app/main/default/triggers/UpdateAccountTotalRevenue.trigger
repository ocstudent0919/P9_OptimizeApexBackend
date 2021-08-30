trigger UpdateAccountTotalRevenue on Order(after update) {
    // Declare a new Set of Account Ids
    Set<Id> setAccountIds = new Set<Id>();
    // Populate the above Set with Account Ids corresponding to certain conditions
    for (Order newOrder : Trigger.new) {
        if (
            newOrder.Status == 'Ordered' &&
            newOrder.Status != Trigger.oldMap.get(newOrder.Id).Status
        ) {
            setAccountIds.add(newOrder.AccountId);
        }
    }
    // Call the service
    if (setAccountIds.size() > 0) {
        AccountService.updateTotalRevenue(setAccountIds);
    }
}
