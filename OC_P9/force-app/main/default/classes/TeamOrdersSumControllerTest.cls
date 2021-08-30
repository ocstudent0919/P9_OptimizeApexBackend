@isTest
private class TeamOrdersSumControllerTest {
    @isTest
    static void testOrdersSum() {
        // Initialize variables
        Integer numAccounts = 3;
        Integer numOrders = 2;
        Integer sumExpected =
            numAccounts *
            numOrders *
            TestDataFactory.ITEM_QUANTITY *
            TestDataFactory.UNIT_PRICE;
        // Load test data
        TestDataFactory.insertTestData(numAccounts, numOrders);
        // Get Order records to update
        Order[] orders = [SELECT id FROM Order];
        // Set new order status for each record
        for (Order order : orders) {
            order.Status = TestDataFactory.FINAL_ORDER_STATUS;
        }
        update orders;

        // Get instance of apex controller
        TeamOrdersSumController controller = new TeamOrdersSumController();
        // Perform the test
        Test.startTest();
        Decimal sum = controller.ordersSum;
        Test.stopTest();

        // Verify that the aggregated value of Order Total Amount
        // corresponds to the expected value
        System.assertEquals(
            sumExpected,
            sum,
            'Incorrect aggregated value of Order Total Amount'
        );
    }

    @isTest
    static void testOrdersSumForNonValidatedOrders() {
        // Initialize variables
        Integer numAccounts = 3;
        Integer numOrders = 2;
        // Load test data
        TestDataFactory.insertTestData(numAccounts, numOrders);

        // Get instance of apex controller
        TeamOrdersSumController controller = new TeamOrdersSumController();
        // Perform the test
        Test.startTest();
        Decimal sum = controller.ordersSum;
        Test.stopTest();

        // Select validated orders
        Order[] ordersWithRightStatus = [
            SELECT id
            FROM Order
            WHERE Status = :TestDataFactory.FINAL_ORDER_STATUS
        ];

        // Confirm that no validated orders are present
        System.assertEquals(
            0,
            ordersWithRightStatus.size(),
            'Unexpected number of orders'
        );
        // Verify that for non-validated orders
        // the aggregated value of Order Total Amount is equal to zero
        System.assertEquals(
            0,
            sum,
            'Incorrect aggregated value of Order Total Amount'
        );
    }
}
