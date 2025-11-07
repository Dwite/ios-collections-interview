# Live Coding Interview - Swift Collections

## Getting Started

1. **Open the project**:
   ```bash
   open LiveCodingInterview.xcodeproj
   ```

2. **Open the files to edit**:
   - Navigate to `LiveCodingInterview/OrderManager.swift` (Tasks 1-3)
   - Navigate to `LiveCodingInterview/ConcurrencyManager.swift` (Task 4)
   - Navigate to `LiveCodingInterview/MemoryManager.swift` (Task 5)

3. **Run the tests**:
   - Press `⌘U` to run all tests
   - All 28 tests will fail initially (expected)
   - After implementing each task, press `⌘U` again to see progress

---

## Your Tasks

### Task 1: Array Filtering & Sorting

```swift
func getCustomerOrders(orders: [Order], customerId: String) -> [Order]
```

Filter orders by customer ID and sort by amount (highest first).

**Example**:
```swift
Input: [Order(id: "1", customerId: "A", amount: 100),
        Order(id: "2", customerId: "B", amount: 200),
        Order(id: "3", customerId: "A", amount: 50)]

getCustomerOrders(orders: input, customerId: "A")
→ [Order(id: "1", amount: 100), Order(id: "3", amount: 50)]
```

---

### Task 2: Dictionary Aggregation

```swift
func getTotalSpendingPerCustomer(orders: [Order]) -> [String: Double]
```

Calculate total spending for each customer.

**Example**:
```swift
Input: [Order(id: "1", customerId: "A", amount: 100),
        Order(id: "2", customerId: "B", amount: 200),
        Order(id: "3", customerId: "A", amount: 50)]

getTotalSpendingPerCustomer(orders: input)
→ ["A": 150.0, "B": 200.0]
```

---

### Task 3: Top N with Sorting

```swift
func getTopCustomers(orders: [Order], limit: Int) -> [(customerId: String, totalSpending: Double)]
```

Find top N customers by total spending (sorted, highest first).

**Example**:
```swift
Input: [Order(id: "1", customerId: "A", amount: 100),
        Order(id: "2", customerId: "B", amount: 200),
        Order(id: "3", customerId: "C", amount: 300),
        Order(id: "4", customerId: "A", amount: 50)]

getTopCustomers(orders: input, limit: 2)
→ [("C", 300.0), ("B", 200.0)]
```

---

### Task 4: Concurrency & Thread Safety

Fix the data race in `ConcurrencyManager.swift` and convert to modern Swift concurrency.

The current implementation has thread-safety issues.

**Example**:
```swift
// Current (unsafe):
func updateOrders(_ newOrders: [Order]) {
    DispatchQueue.global().async {
        self.orders = newOrders
    }
}

// Expected (safe):
// Refactor to use async/await and proper thread safety
```

---

### Task 5: Memory Management

Fix the retain cycles in `MemoryManager.swift`.

The current implementation has memory leaks.

**Example**:
```swift
// Current (memory leak):
orderCache?.onOrdersUpdated = { newOrders in
    self.orders = newOrders
    self.processOrders()
}

// Expected (no leak):
// Fix retain cycles using weak/unowned self
```

---

## Running Tests

- **All tests**: Press `⌘U`
- **Single test**: Click ◇ diamond next to test function
- **Test Navigator**: Press `⌘6`

---

Good luck! 🚀
