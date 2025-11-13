import Foundation

// MARK: - Simple Models

struct Order {
    let id: String
    let customerId: String
    let amount: Double
}

// MARK: - Interview Tasks

class OrderManager {

    // MARK: - Task 1: Array Filtering

    /// Find all orders for a specific customer and return them sorted by amount (highest first)
    ///
    /// Example:
    /// ```
    /// let orders = [
    ///     Order(id: "1", customerId: "A", amount: 100),
    ///     Order(id: "2", customerId: "B", amount: 200),
    ///     Order(id: "3", customerId: "A", amount: 50)
    /// ]
    /// getCustomerOrders(orders: orders, customerId: "A")
    /// // Returns: [Order(id: "1", ..., amount: 100), Order(id: "3", ..., amount: 50)]
    /// ```
    ///
    /// - Parameters:
    ///   - orders: Array of all orders
    ///   - customerId: Customer ID to filter by
    /// - Returns: Array of orders for that customer, sorted by amount descending
    func getCustomerOrders(orders: [Order], customerId: String) -> [Order] {
        // TODO: Implement
        return []
    }

    // MARK: - Task 2: Dictionary Aggregation

    /// Calculate total spending per customer
    ///
    /// Example:
    /// ```
    /// let orders = [
    ///     Order(id: "1", customerId: "A", amount: 100),
    ///     Order(id: "2", customerId: "B", amount: 200),
    ///     Order(id: "3", customerId: "A", amount: 50)
    /// ]
    /// getTotalSpendingPerCustomer(orders: orders)
    /// // Returns: ["A": 150.0, "B": 200.0]
    /// ```
    ///
    /// - Parameter orders: Array of all orders
    /// - Returns: Dictionary mapping customerId to total amount spent
    func getTotalSpendingPerCustomer(orders: [Order]) -> [String: Double] {
        // TODO: Implement
        return [:]
    }

    // MARK: - Task 3: Top N with Sorting

    /// Find the top N customers by total spending
    ///
    /// Example:
    /// ```
    /// let orders = [
    ///     Order(id: "1", customerId: "A", amount: 100),
    ///     Order(id: "2", customerId: "B", amount: 200),
    ///     Order(id: "3", customerId: "C", amount: 300),
    ///     Order(id: "4", customerId: "A", amount: 50)
    /// ]
    /// getTopCustomers(orders: orders, limit: 2)
    /// // Returns: [("C", 300.0), ("B", 200.0)]
    /// ```
    ///
    /// HINT: Reuse getTotalSpendingPerCustomer logic if needed
    ///
    /// - Parameters:
    ///   - orders: Array of all orders
    ///   - limit: Number of top customers to return
    /// - Returns: Array of tuples (customerId, totalSpending) sorted by spending descending
    func getTopCustomers(orders: [Order], limit: Int) -> [(customerId: String, totalSpending: Double)] {
        // TODO: Implement
        // HINT: Reuse getTotalSpendingPerCustomer logic if needed
        return []
    }
}
