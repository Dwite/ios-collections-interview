import Foundation

// MARK: - Task 5: Memory Management

final class MemoryManager: NSObject {

    /// Requirements:
    /// - MemoryManager and OrderCache should properly deallocate when no longer in use
    /// - All functionality should continue to work correctly
    /// - All tests should pass

    private var orders: [Order] = []
    private var orderCache: OrderCache?

    func setupOrderCache() {
        orderCache = OrderCache()

        orderCache?.onOrdersUpdated = { newOrders in
            self.orders = newOrders
            self.processOrders()
        }
    }

    func processOrders() {
        orderCache?.fetchOrders { result in
            self.orders = result
            print("Fetched \(self.orders.count) orders")
        }
    }
}

class OrderCache: NSObject {
    var onOrdersUpdated: (([Order]) -> Void)?

    func fetchOrders(completion: @escaping ([Order]) -> Void) {
        // Simulated async fetch
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            completion([])
        }
    }
}
