import XCTest
@testable import LiveCodingInterview

final class OrderManagerTests: XCTestCase {

    var manager: OrderManager!

    override func setUp() {
        super.setUp()
        manager = OrderManager()
    }

    override func tearDown() {
        manager = nil
        super.tearDown()
    }

    // MARK: - Task 1 Tests: Array Filtering

    func test_task1_getCustomerOrders_basic() {
        // Given
        let orders = [
            Order(id: "1", customerId: "A", amount: 100),
            Order(id: "2", customerId: "B", amount: 200),
            Order(id: "3", customerId: "A", amount: 50)
        ]

        // When
        let result = manager.getCustomerOrders(orders: orders, customerId: "A")

        // Then
        XCTAssertEqual(result.count, 2, "Should return 2 orders for customer A")
        XCTAssertEqual(result[0].id, "1", "First order should be highest amount")
        XCTAssertEqual(result[0].amount, 100)
        XCTAssertEqual(result[1].id, "3")
        XCTAssertEqual(result[1].amount, 50)
    }

    func test_task1_getCustomerOrders_sortedDescending() {
        // Given
        let orders = [
            Order(id: "1", customerId: "A", amount: 50),
            Order(id: "2", customerId: "A", amount: 200),
            Order(id: "3", customerId: "A", amount: 100)
        ]

        // When
        let result = manager.getCustomerOrders(orders: orders, customerId: "A")

        // Then
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0].amount, 200, "Should be sorted highest to lowest")
        XCTAssertEqual(result[1].amount, 100)
        XCTAssertEqual(result[2].amount, 50)
    }

    func test_task1_getCustomerOrders_noMatches() {
        // Given
        let orders = [
            Order(id: "1", customerId: "A", amount: 100),
            Order(id: "2", customerId: "B", amount: 200)
        ]

        // When
        let result = manager.getCustomerOrders(orders: orders, customerId: "C")

        // Then
        XCTAssertEqual(result.count, 0, "Should return empty array when no matches")
    }

    func test_task1_getCustomerOrders_emptyInput() {
        // Given
        let orders: [Order] = []

        // When
        let result = manager.getCustomerOrders(orders: orders, customerId: "A")

        // Then
        XCTAssertEqual(result.count, 0, "Should handle empty input")
    }

    // MARK: - Task 2 Tests: Dictionary Aggregation

    func test_task2_getTotalSpending_basic() {
        // Given
        let orders = [
            Order(id: "1", customerId: "A", amount: 100),
            Order(id: "2", customerId: "B", amount: 200),
            Order(id: "3", customerId: "A", amount: 50)
        ]

        // When
        let result = manager.getTotalSpendingPerCustomer(orders: orders)

        // Then
        XCTAssertEqual(result["A"], 150.0, "Customer A should have total 150")
        XCTAssertEqual(result["B"], 200.0, "Customer B should have total 200")
        XCTAssertEqual(result.count, 2, "Should have 2 customers")
    }

    func test_task2_getTotalSpending_singleCustomer() {
        // Given
        let orders = [
            Order(id: "1", customerId: "A", amount: 100),
            Order(id: "2", customerId: "A", amount: 200),
            Order(id: "3", customerId: "A", amount: 300)
        ]

        // When
        let result = manager.getTotalSpendingPerCustomer(orders: orders)

        // Then
        XCTAssertEqual(result["A"], 600.0, "Should sum all orders for single customer")
        XCTAssertEqual(result.count, 1)
    }

    func test_task2_getTotalSpending_multipleCustomers() {
        // Given
        let orders = [
            Order(id: "1", customerId: "A", amount: 100),
            Order(id: "2", customerId: "B", amount: 200),
            Order(id: "3", customerId: "C", amount: 300),
            Order(id: "4", customerId: "A", amount: 50),
            Order(id: "5", customerId: "B", amount: 75)
        ]

        // When
        let result = manager.getTotalSpendingPerCustomer(orders: orders)

        // Then
        XCTAssertEqual(result["A"], 150.0)
        XCTAssertEqual(result["B"], 275.0)
        XCTAssertEqual(result["C"], 300.0)
        XCTAssertEqual(result.count, 3)
    }

    func test_task2_getTotalSpending_emptyInput() {
        // Given
        let orders: [Order] = []

        // When
        let result = manager.getTotalSpendingPerCustomer(orders: orders)

        // Then
        XCTAssertEqual(result.count, 0, "Should return empty dictionary for empty input")
    }

    // MARK: - Task 3 Tests: Top N Customers

    func test_task3_getTopCustomers_basic() {
        // Given
        let orders = [
            Order(id: "1", customerId: "A", amount: 100),
            Order(id: "2", customerId: "B", amount: 200),
            Order(id: "3", customerId: "C", amount: 300),
            Order(id: "4", customerId: "A", amount: 50)
        ]

        // When
        let result = manager.getTopCustomers(orders: orders, limit: 2)

        // Then
        XCTAssertEqual(result.count, 2, "Should return top 2 customers")
        XCTAssertEqual(result[0].customerId, "C", "C should be #1 with 300")
        XCTAssertEqual(result[0].totalSpending, 300.0)
        XCTAssertEqual(result[1].customerId, "B", "B should be #2 with 200")
        XCTAssertEqual(result[1].totalSpending, 200.0)
    }

    func test_task3_getTopCustomers_limitGreaterThanCustomers() {
        // Given
        let orders = [
            Order(id: "1", customerId: "A", amount: 100),
            Order(id: "2", customerId: "B", amount: 200)
        ]

        // When
        let result = manager.getTopCustomers(orders: orders, limit: 5)

        // Then
        XCTAssertEqual(result.count, 2, "Should return all customers when limit exceeds count")
    }

    func test_task3_getTopCustomers_sortedCorrectly() {
        // Given
        let orders = [
            Order(id: "1", customerId: "A", amount: 100),
            Order(id: "2", customerId: "B", amount: 500),
            Order(id: "3", customerId: "C", amount: 200),
            Order(id: "4", customerId: "D", amount: 300),
            Order(id: "5", customerId: "A", amount: 400) // A total: 500
        ]

        // When
        let result = manager.getTopCustomers(orders: orders, limit: 3)

        // Then
        XCTAssertEqual(result.count, 3)
        // B: 500, A: 500, D: 300 (B and A tied, order may vary)
        XCTAssertTrue(result[0].totalSpending >= 500, "Top customer should have >= 500")
        XCTAssertTrue(result[1].totalSpending >= 500 || result[1].totalSpending == 300)
        XCTAssertTrue(result[2].totalSpending >= 300, "Third customer should have >= 300")
    }

    func test_task3_getTopCustomers_emptyInput() {
        // Given
        let orders: [Order] = []

        // When
        let result = manager.getTopCustomers(orders: orders, limit: 3)

        // Then
        XCTAssertEqual(result.count, 0, "Should handle empty input")
    }

    func test_task3_getTopCustomers_limitZero() {
        // Given
        let orders = [
            Order(id: "1", customerId: "A", amount: 100)
        ]

        // When
        let result = manager.getTopCustomers(orders: orders, limit: 0)

        // Then
        XCTAssertEqual(result.count, 0, "Should return empty array when limit is 0")
    }
}
