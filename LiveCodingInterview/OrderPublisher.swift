import Foundation
import Combine

// MARK: - Task 6: Combine

class OrderPublisher {

    /// Implement the missing functionality and fix subscription issues.
    ///
    /// Requirements:
    /// - getOrdersPublisher() should return a publisher that emits order updates
    /// - Subscriptions should persist across multiple publish events
    /// - Multiple subscribers should be able to receive updates
    /// - All tests should pass
    ///
    /// Current implementation (incomplete):

    private var orders: [Order] = []
    private let orderSubject = CurrentValueSubject<[Order], Never>([])

    private let orderSubject = PassthroughSubject<[Order], Never>()
    private var highValueCancellables: Set<AnyCancellable> = []
    
    func publishOrders(_ newOrders: [Order]) {
        orders = newOrders
        orderSubject.send(newOrders)
    }
    
    func getOrdersPublisher() -> AnyPublisher<[Order], Never> {
        fatalError("Not implemented")
        orderSubject.eraseToAnyPublisher()
    }

    func subscribeToHighValueOrders(threshold: Double, handler: @escaping ([Order]) -> Void) {
        // TODO: Subscribed once handler should be called with orders: order.amount >= threshold on each orders array update
        fatalError("Not implemented")
    }
    
    //Converts async method into publisher
    func fetchOrders() -> AnyPublisher<[Order], Error> {
        // TODO: Use next async method to return a publisher
        // func fetchOrders() async throws -> [Order]
        fatalError("Not implemented")
    }
    
    //Convertes publisher into async method
    func ordersFromPublisher() async throws -> [Order] {
        // TODO: Use next method returning a publidher to return orders array asynchronously
        // func fetchOrdersPublisher() -> AnyPublisher<[Order], Error>
        fatalError("Not implemented")
    }
}

private extension OrderPublisher {
    func fetchOrders() async throws -> [Order] {
        // Simulate network delay of 1 second
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second in nanoseconds
        
        // Return mock orders
        let orders = [
            Order(id: "1", customerId: "A", amount: 100),
            Order(id: "2", customerId: "B", amount: 250),
            Order(id: "3", customerId: "C", amount: 300)
        ]
        return orders
    }
    
    func fetchOrdersPublisher() -> AnyPublisher<[Order], Error> {
        let orders = [
            Order(id: "1", customerId: "A", amount: 100),
            Order(id: "2", customerId: "B", amount: 250),
            Order(id: "3", customerId: "C", amount: 300)
        ]
        
        return Just(orders)
            .delay(for: 1.0, scheduler: DispatchQueue.global())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
