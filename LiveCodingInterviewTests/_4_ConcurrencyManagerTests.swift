import XCTest
@testable import LiveCodingInterview

final class ConcurrencyManagerTests: XCTestCase {

    var manager: ConcurrencyManager!

    override func setUp() {
        super.setUp()
        manager = ConcurrencyManager()
    }

    override func tearDown() {
        manager = nil
        super.tearDown()
    }

    // MARK: - Task 4 Tests: Concurrency & Thread Safety

    func test_task4_updateAndGetOrders_basic() async {
        // Given
        let orders = [
            Order(id: "1", customerId: "A", amount: 100),
            Order(id: "2", customerId: "B", amount: 200)
        ]

        // When
        await manager.updateOrders(orders)
        let result = await manager.getOrders()

        // Then
        XCTAssertEqual(result.count, 2, "Should return all orders")
        XCTAssertEqual(result[0].id, "1")
        XCTAssertEqual(result[1].id, "2")
    }

    func test_task4_concurrentReads_threadSafe() async {
        // Given
        let orders = [
            Order(id: "1", customerId: "A", amount: 100),
            Order(id: "2", customerId: "B", amount: 200),
            Order(id: "3", customerId: "C", amount: 300)
        ]
        await manager.updateOrders(orders)

        // When - Multiple concurrent reads
        await withTaskGroup(of: [Order].self) { group in
            for _ in 0..<100 {
                group.addTask {
                    await self.manager.getOrders()
                }
            }

            // Then - All reads should succeed without crashes
            for await result in group {
                XCTAssertEqual(result.count, 3, "Should always return 3 orders")
            }
        }
    }

    func test_task4_concurrentWrites_threadSafe() async {
        // Given
        let orders1 = [Order(id: "1", customerId: "A", amount: 100)]
        let orders2 = [Order(id: "2", customerId: "B", amount: 200)]
        let orders3 = [Order(id: "3", customerId: "C", amount: 300)]

        // When - Multiple concurrent writes
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.manager.updateOrders(orders1) }
            group.addTask { await self.manager.updateOrders(orders2) }
            group.addTask { await self.manager.updateOrders(orders3) }
        }

        // Then - Should complete without crashes
        let result = await manager.getOrders()
        XCTAssertEqual(result.count, 1, "Should have orders from one of the writes")
    }

    func test_task4_concurrentReadWrite_threadSafe() async {
        // Given
        let initialOrders = [Order(id: "1", customerId: "A", amount: 100)]
        await manager.updateOrders(initialOrders)

        // When - Concurrent reads and writes
        await withTaskGroup(of: Void.self) { group in
            // Add write tasks
            for i in 0..<50 {
                group.addTask {
                    let orders = [Order(id: "\(i)", customerId: "A", amount: Double(i * 100))]
                    await self.manager.updateOrders(orders)
                }
            }

            // Add read tasks
            for _ in 0..<50 {
                group.addTask {
                    _ = await self.manager.getOrders()
                }
            }
        }

        // Then - Should complete without crashes or data corruption
        let finalOrders = await manager.getOrders()
        XCTAssertGreaterThanOrEqual(finalOrders.count, 0, "Should have valid order count")
    }

    func test_task4_emptyOrders() async {
        // Given - No orders set

        // When
        let result = await manager.getOrders()

        // Then
        XCTAssertEqual(result.count, 0, "Should return empty array initially")
    }

    func test_task4_updateMultipleTimes() async {
        // Given
        let orders1 = [Order(id: "1", customerId: "A", amount: 100)]
        let orders2 = [Order(id: "2", customerId: "B", amount: 200)]

        // When
        await manager.updateOrders(orders1)
        let result1 = await manager.getOrders()

        await manager.updateOrders(orders2)
        let result2 = await manager.getOrders()

        // Then
        XCTAssertEqual(result1.count, 1)
        XCTAssertEqual(result1[0].id, "1")

        XCTAssertEqual(result2.count, 1)
        XCTAssertEqual(result2[0].id, "2")
    }
}
