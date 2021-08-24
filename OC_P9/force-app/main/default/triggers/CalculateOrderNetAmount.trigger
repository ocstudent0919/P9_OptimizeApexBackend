trigger CalculateOrderNetAmount on Order(before update) {
    for (Order newOrder : Trigger.new) {
        newOrder.NetAmount__c = newOrder.ShipmentCost__c == null
            ? newOrder.TotalAmount
            : newOrder.TotalAmount - newOrder.ShipmentCost__c;
    }
}
