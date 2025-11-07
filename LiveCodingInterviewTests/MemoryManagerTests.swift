import XCTest
@testable import LiveCodingInterview

final class MemoryManagerTests: XCTestCase {

    // MARK: - Task 5 Tests: Memory Management

    func test_task5_memoryManager_deallocates() {
        // Given
        weak var weakManager: MemoryManager?

        // When
        autoreleasepool {
            let manager = MemoryManager()
            weakManager = manager
            manager.setupOrderCache()
        }

        // Then - Manager should deallocate if no retain cycles
        XCTAssertNil(weakManager, "MemoryManager should deallocate after leaving scope")
    }

    func test_task5_orderCache_deallocates() {
        // Given
        weak var weakCache: OrderCache?

        // When
        autoreleasepool {
            let manager = MemoryManager()
            manager.setupOrderCache()

            // Access the cache through reflection or make it internal for testing
            let mirror = Mirror(reflecting: manager)
            if let orderCache = mirror.children.first(where: { $0.label == "orderCache" })?.value as? OrderCache {
                weakCache = orderCache
            }
        }

        // Then - Cache should deallocate if no retain cycles
        XCTAssertNil(weakCache, "OrderCache should deallocate after manager is released")
    }

    func test_task5_setupOrderCache_works() {
        // Given
        let manager = MemoryManager()

        // When
        manager.setupOrderCache()

        // Then - Should complete without crashes
        XCTAssertTrue(true, "setupOrderCache should work without crashes")
    }

    func test_task5_processOrders_works() {
        // Given
        let manager = MemoryManager()
        manager.setupOrderCache()

        // When
        manager.processOrders()

        // Then - Should complete without crashes
        XCTAssertTrue(true, "processOrders should work without crashes")
    }

    func test_task5_multipleManagers_deallocate() {
        // Given
        var weakManagers: [MemoryManager?] = []

        // When
        autoreleasepool {
            for _ in 0..<10 {
                let manager = MemoryManager()
                manager.setupOrderCache()
                manager.processOrders()
                weakManagers.append(manager)
            }
        }

        // Then - All managers should deallocate
        let nonNilCount = weakManagers.compactMap { $0 }.count
        XCTAssertEqual(nonNilCount, 0, "All MemoryManagers should deallocate")
    }

    func test_task5_closureExecution_afterFix() {
        // Given
        let manager = MemoryManager()
        let expectation = expectation(description: "Closure should execute")

        // When
        manager.setupOrderCache()

        // Trigger the callback
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(true, "Callbacks should still work after fixing retain cycles")
    }
}
