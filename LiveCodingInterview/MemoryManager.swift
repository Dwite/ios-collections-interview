import Foundation

// MARK: - Task 5: Memory Management

final class MemoryManager: NSObject {

    /// Fix the memory leaks caused by retain cycles in the closures below.
    ///
    /// Requirements:
    /// - MemoryManager and OrderCache should properly deallocate when no longer in use
    /// - Closures should not create strong reference cycles
    /// - All functionality should continue to work correctly
    /// - All tests should pass
    ///
    /// Current implementation (has memory leaks):

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
        let sortedOrders = orders.sorted { $0.amount > $1.amount }

        orderCache?.fetchOrders { result in
            self.orders = result
            print("Fetched \(self.orders.count) orders")
        }
    }

    // TODO: Fix the retain cycles to meet requirements
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
