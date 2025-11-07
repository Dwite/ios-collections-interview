import Foundation

// MARK: - Task 5: Memory Management

class MemoryManager {

    /// Fix the retain cycles in the code below
    /// The current implementation causes memory leaks

    private var orders: [Order] = []
    private var orderCache: OrderCache?

    func setupOrderCache() {
        orderCache = OrderCache()

        // ⚠️ Retain cycle here
        orderCache?.onOrdersUpdated = { newOrders in
            self.orders = newOrders
            self.processOrders()
        }
    }

    func processOrders() {
        let sortedOrders = orders.sorted { $0.amount > $1.amount }

        // ⚠️ Retain cycle here
        orderCache?.fetchOrders { result in
            self.orders = result
            print("Fetched \(self.orders.count) orders")
        }
    }

    // TODO: Fix the retain cycles above
}

class OrderCache {
    var onOrdersUpdated: (([Order]) -> Void)?

    func fetchOrders(completion: @escaping ([Order]) -> Void) {
        // Simulated async fetch
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            completion([])
        }
    }
}
