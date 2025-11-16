import XCTest
import Combine
@testable import LiveCodingInterview

final class OrderPublisherTests: XCTestCase {

    var publisher: OrderPublisher!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        publisher = OrderPublisher()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        publisher = nil
        super.tearDown()
    }

    // MARK: - Task 6 Tests: Combine

    func test_task6_getOrdersPublisher_emitsValues() {
        // Given
        let expectation = expectation(description: "Publisher should emit new orders only once")
        let orders = [
            Order(id: "1", customerId: "A", amount: 100),
            Order(id: "2", customerId: "B", amount: 200)
        ]

        var receivedOrders: [Order] = []

        // When
        publisher.getOrdersPublisher()
            .sink { orders in
                receivedOrders = orders
                expectation.fulfill()
            }
            .store(in: &cancellables)

        publisher.publishOrders(orders)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedOrders.count, 2, "Should receive published orders")
        XCTAssertEqual(receivedOrders[0].id, "1")
        XCTAssertEqual(receivedOrders[1].id, "2")
    }

    func test_task6_subscribeToHighValueOrders_filtersCorrectly() {
        // Given
        let expectation = expectation(description: "Should receive filtered orders")
        let orders = [
            Order(id: "1", customerId: "A", amount: 100),
            Order(id: "2", customerId: "B", amount: 250),
            Order(id: "3", customerId: "C", amount: 300)
        ]

        var receivedOrders: [Order] = []

        // When
        publisher.subscribeToHighValueOrders(threshold: 200) { filtered in
            receivedOrders = filtered
            expectation.fulfill()
        }

        publisher.publishOrders(orders)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedOrders.count, 2, "Should only receive orders >= 200")
        XCTAssertTrue(receivedOrders.allSatisfy { $0.amount >= 200 })
    }

    func test_task6_multipleSubscribers_allReceiveValues() {
        // Given
        let expectation1 = expectation(description: "Subscriber 1")
        let expectation2 = expectation(description: "Subscriber 2")
        let orders = [Order(id: "1", customerId: "A", amount: 100)]

        var received1: [Order] = []
        var received2: [Order] = []

        // When
        publisher.getOrdersPublisher()
            .sink { orders in
                received1 = orders
                expectation1.fulfill()
            }
            .store(in: &cancellables)

        publisher.getOrdersPublisher()
            .sink { orders in
                received2 = orders
                expectation2.fulfill()
            }
            .store(in: &cancellables)

        publisher.publishOrders(orders)

        // Then
        wait(for: [expectation1, expectation2], timeout: 1.0)
        XCTAssertEqual(received1.count, 1, "Subscriber 1 should receive orders")
        XCTAssertEqual(received2.count, 1, "Subscriber 2 should receive orders")
    }

    func test_task6_subscriptionPersists_multiplePublishes() {
        // Given
        let expectation = expectation(description: "Should receive multiple updates")
        expectation.expectedFulfillmentCount = 2

        let orders1 = [Order(id: "1", customerId: "A", amount: 100)]
        let orders2 = [Order(id: "2", customerId: "B", amount: 200)]

        var receivedCount = 0

        // When
        publisher.getOrdersPublisher()
            .sink { _ in
                receivedCount += 1
                expectation.fulfill()
            }
            .store(in: &cancellables)

        publisher.publishOrders(orders1)
        publisher.publishOrders(orders2)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedCount, 2, "Subscription should persist across multiple publishes")
    }

    func test_task6_emptyOrders_publishes() {
        // Given
        let expectation = expectation(description: "Should handle empty orders")
        var received: [Order] = []

        // When
        publisher.getOrdersPublisher()
            .sink { orders in
                received = orders
                expectation.fulfill()
            }
            .store(in: &cancellables)

        publisher.publishOrders([])

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(received.count, 0, "Should handle empty order array")
    }

    func test_task6_highValueSubscription_persists() {
        // Given
        let expectation = expectation(description: "High value subscription persists")
        expectation.expectedFulfillmentCount = 2

        let orders1 = [Order(id: "1", customerId: "A", amount: 300)]
        let orders2 = [Order(id: "2", customerId: "B", amount: 400)]

        var callCount = 0

        // When
        publisher.subscribeToHighValueOrders(threshold: 200) { _ in
            callCount += 1
            expectation.fulfill()
        }

        publisher.publishOrders(orders1)
        publisher.publishOrders(orders2)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(callCount, 2, "High value subscription should persist")
    }

    func test_fetchOrders_emitsOrders() {
        // Given
        let expectation1 = expectation(description: "Should receive orders from first fetchOrders call")
        let expectation2 = expectation(description: "Should receive orders from second fetchOrders call")
        var firstCallOrders: [Order] = []
        var secondCallOrders: [Order] = []
        var receivedError: Error?

        // When - First subscriber
        let fetch_publicher = publisher.fetchOrders()
        fetch_publicher
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        expectation1.fulfill()
                    case .failure(let error):
                        receivedError = error
                    }
                },
                receiveValue: { orders in
                    firstCallOrders = orders
                }
            )
            .store(in: &cancellables)

        // Wait for first call to complete
        wait(for: [expectation1], timeout: 2.0)
        
        // Second subscriber
        fetch_publicher
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        expectation2.fulfill()
                    case .failure(let error):
                        receivedError = error
                    }
                },
                receiveValue: { orders in
                    secondCallOrders = orders
                }
            )
            .store(in: &cancellables)

        // Then
        wait(for: [expectation2], timeout: 2.0)
        XCTAssertNil(receivedError, "Should not receive an error")
        XCTAssertEqual(firstCallOrders.count, 3, "Should receive 3 orders from first call")
        XCTAssertEqual(secondCallOrders.count, 3, "Should receive 3 orders from second call")
        
        // Verify orders are different
        XCTAssertNotEqual(firstCallOrders[0].id, secondCallOrders[0].id, "First order IDs should be different")
        XCTAssertNotEqual(firstCallOrders[0].customerId, secondCallOrders[0].customerId, "First order customer IDs should be different")
        XCTAssertNotEqual(firstCallOrders[0].amount, secondCallOrders[0].amount, "First order amounts should be different")
    }

    // MARK: - ordersFromPublisher() Tests

    func test_ordersFromPublisher_returnsOrders() async throws {
        // Given & When - First call
        let firstCallOrders = try await publisher.ordersFromPublisher()
        
        // Second call
        let secondCallOrders = try await publisher.ordersFromPublisher()

        // Then
        XCTAssertEqual(firstCallOrders.count, 3, "Should receive 3 orders from first call")
        XCTAssertEqual(secondCallOrders.count, 3, "Should receive 3 orders from second call")
        
        // Verify orders are different
        XCTAssertNotEqual(firstCallOrders[0].id, secondCallOrders[0].id, "First order IDs should be different")
        XCTAssertNotEqual(firstCallOrders[0].customerId, secondCallOrders[0].customerId, "First order customer IDs should be different")
        XCTAssertNotEqual(firstCallOrders[0].amount, secondCallOrders[0].amount, "First order amounts should be different")
    }

}
