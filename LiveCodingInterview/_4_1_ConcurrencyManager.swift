import Foundation

// MARK: - Task 4.1: Concurrency & Thread Safety

class ConcurrencyManager {

    /// Refactor this code to use modern Swift concurrency (async/await)
    ///
    /// Requirements:
    /// - Convert callback-based methods to async/await
    /// - All tests should pass
    ///
    /// Current implementation:

    private var orders: [Order] = []

    func updateOrders(_ newOrders: [Order]) {
        DispatchQueue.global().async {
            self.orders = newOrders
        }
    }

    func getOrders(completion: @escaping ([Order]) -> Void) {
        DispatchQueue.global().async {
            completion(self.orders)
        }
    }

    // TODO: Refactor above to meet requirements
}
