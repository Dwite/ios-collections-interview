import Foundation
import Combine

// MARK: - Task 6: Combine

class OrderPublisher {

    /// Implement the missing functionality and fix subscription issues.
    ///
    /// Requirements:
    /// - getOrdersPublisher() should return a publisher that emits order updates made from outside through publishOrders(_ newOrders: [Order])
    /// - Subscriptions should persist across multiple publish events
    /// - Multiple subscribers should be able to receive updates
    /// - All tests should pass
    ///
    /// Current implementation (incomplete):

    private var orders: [Order] = []
    private let orderSubject = CurrentValueSubject<[Order], Never>([])
    private var callCount: Int = 0
    
    func publishOrders(_ newOrders: [Order]) {
        orders = newOrders
        orderSubject.send(newOrders)
    }
    
    func getOrdersPublisher() -> AnyPublisher<[Order], Never> {
        // TODO: Implement
        fatalError("Not implemented")
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
    
    //Converts publisher into async method
    func ordersFromPublisher() async throws -> [Order] {
        // TODO: Use next method returning a publidher to return orders array asynchronously
        // func fetchOrdersPublisher() -> AnyPublisher<[Order], Error>
        fatalError("Not implemented")
    }
}


//Simulated API used in convertion methods above - don't change it
private extension OrderPublisher {
    func fetchOrders() async throws -> [Order] {
        // Simulate network delay of 1 second
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Increment call count to return different orders each time
        callCount += 1
        
        // Return mock orders with varying data based on call count
        let orders = [
            Order(id: "\(callCount)-1", customerId: "A\(callCount)", amount: 100.0 + Double(callCount * 10)),
            Order(id: "\(callCount)-2", customerId: "B\(callCount)", amount: 250.0 + Double(callCount * 15)),
            Order(id: "\(callCount)-3", customerId: "C\(callCount)", amount: 300.0 + Double(callCount * 20))
        ]
        return orders
    }
    
    func fetchOrdersPublisher() -> AnyPublisher<[Order], Error> {
        // Increment call count to return different orders each time
        callCount += 1
        
        // Return mock orders with varying data based on call count
        let orders = [
            Order(id: "\(callCount)-1", customerId: "A\(callCount)", amount: 100.0 + Double(callCount * 10)),
            Order(id: "\(callCount)-2", customerId: "B\(callCount)", amount: 250.0 + Double(callCount * 15)),
            Order(id: "\(callCount)-3", customerId: "C\(callCount)", amount: 300.0 + Double(callCount * 20))
        ]
        
        return Just(orders)
            .delay(for: 1.0, scheduler: DispatchQueue.global())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
