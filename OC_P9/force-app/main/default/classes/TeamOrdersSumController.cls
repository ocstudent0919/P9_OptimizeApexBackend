public without sharing class TeamOrdersSumController {
    public Decimal ordersSum {
        get {
            AggregateResult groupedResults = [
                SELECT SUM(TotalAmount) total
                FROM Order
                WHERE Status = 'Ordered'
            ];
            if (groupedResults.get('total') == null) {
                return 0;
            }
            return (Decimal) groupedResults.get('total');
        }
        set;
    }
}
