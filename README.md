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
   - Navigate to `LiveCodingInterview/OrderPublisher.swift` (Task 6)
   - Navigate to `LiveCodingInterview/OrderLegacy.swift` (Task 7)

3. **Run the tests**:
   - Press `⌘U` to run all tests
   - All 42 tests will fail initially (expected)
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

Refactor `ConcurrencyManager.swift` to use modern Swift concurrency and make it thread-safe.

**Requirements**:
- Convert callback-based methods to async/await
- Ensure thread-safe access to the orders array (no data races)
- All tests should pass without crashes or race conditions

---

### Task 5: Memory Management

Fix the memory leaks in `MemoryManager.swift` caused by retain cycles.

**Requirements**:
- MemoryManager and OrderCache should properly deallocate when no longer in use
- Closures should not create strong reference cycles
- All functionality should continue to work correctly
- All tests should pass

---

### Task 6: Combine

Implement missing functionality and fix subscription issues in `OrderPublisher.swift`.

**Requirements**:
- `getOrdersPublisher()` should return a publisher that emits order updates
- Subscriptions should persist across multiple publish events
- Multiple subscribers should be able to receive updates
- All tests should pass

---

### Task 7: Objective-C to Swift Migration

Migrate legacy Objective-C-style code in `OrderLegacy.swift` to modern Swift patterns.

**Requirements**:
- Replace NSCoding with Codable for serialization
- Convert to struct (value type) where appropriate instead of class
- Replace completion handlers with async/await
- Use Swift native types (String, Double) instead of Foundation types (NSString, NSNumber)
- Replace NSDictionary with type-safe structs
- Use modern observer pattern (Combine/delegate) instead of NotificationCenter
- Maintain backward compatibility with existing NSCoding data
- All tests should pass

---

## Running Tests

- **All tests**: Press `⌘U`
- **Single test**: Click ◇ diamond next to test function
- **Test Navigator**: Press `⌘6`

---

Good luck! 🚀
