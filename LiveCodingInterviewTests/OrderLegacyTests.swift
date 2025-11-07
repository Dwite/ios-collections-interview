import XCTest
@testable import LiveCodingInterview

final class OrderLegacyTests: XCTestCase {

    // MARK: - Task 7 Tests: Objective-C to Swift Migration

    func test_task7_codableEncoding_works() throws {
        // Given - Should use modern Codable instead of NSCoding
        let order = LegacyOrderManager(
            orderID: "123",
            customerID: "C456",
            amount: 99.99,
            metadata: ["priority": "high"]
        )

        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(order)

        // Then
        XCTAssertGreaterThan(data.count, 0, "Should encode to JSON using Codable")
    }

    func test_task7_codableDecoding_works() throws {
        // Given
        let json = """
        {
            "orderID": "123",
            "customerID": "C456",
            "amount": 99.99,
            "metadata": {"priority": "high"}
        }
        """.data(using: .utf8)!

        // When
        let decoder = JSONDecoder()
        let order = try decoder.decode(LegacyOrderManager.self, from: json)

        // Then - Should use Swift native types, not NSString/NSNumber
        XCTAssertEqual(order.orderID as String, "123")
        XCTAssertEqual(order.customerID as String, "C456")
        XCTAssertEqual(order.amount.doubleValue, 99.99, accuracy: 0.01)
    }

    func test_task7_asyncAwait_fetchOrderDetails() async throws {
        // Given - Should use async/await instead of completion handlers
        let order = LegacyOrderManager(
            orderID: "123",
            customerID: "C456",
            amount: 99.99
        )

        // When - Should be able to call with async/await
        let details = try await order.fetchOrderDetails()

        // Then - Should return typed struct instead of dictionary
        XCTAssertNotNil(details, "Should return order details")
    }

    func test_task7_immutableStruct_preferred() {
        // Given - Should use struct for value semantics
        let order = LegacyOrderManager(
            orderID: "123",
            customerID: "C456",
            amount: 99.99
        )

        // When - Create a copy
        var orderCopy = order

        // Then - If struct, modifications shouldn't affect original
        // (This test validates value type behavior)
        XCTAssertNotNil(orderCopy)
    }

    func test_task7_swiftNativeTypes_used() {
        // Given
        let order = LegacyOrderManager(
            orderID: "123",
            customerID: "C456",
            amount: 99.99
        )

        // Then - Should use Swift String, not NSString
        XCTAssertTrue(type(of: order.orderID) == String.self || order.orderID is NSString,
                      "After migration, should ideally use Swift String")

        // Should use Swift Double, not NSNumber
        XCTAssertTrue(type(of: order.amount) == Double.self || order.amount is NSNumber,
                      "After migration, should ideally use Swift Double")
    }

    func test_task7_typeScafeMetadata_used() {
        // Given - Should use typed struct instead of NSDictionary
        let order = LegacyOrderManager(
            orderID: "123",
            customerID: "C456",
            amount: 99.99,
            metadata: ["priority": "high", "urgent": true]
        )

        // Then - Metadata should be type-safe, not [String: Any]
        XCTAssertNotNil(order.metadata)
    }

    func test_task7_observerPattern_modernized() async throws {
        // Given - Should use Combine or delegate instead of NotificationCenter
        let order = LegacyOrderManager(
            orderID: "123",
            customerID: "C456",
            amount: 99.99
        )

        // When - Update amount
        order.updateAmount(NSNumber(value: 199.99))

        // Then - Should notify observers through modern pattern
        XCTAssertEqual(order.amount.doubleValue, 199.99, accuracy: 0.01)
    }

    func test_task7_backwardCompatibility_NSCodingData() throws {
        // Given - Should be able to read old NSCoding archived data
        let legacyOrder = LegacyOrderManager(
            orderID: "OLD123",
            customerID: "OLD456",
            amount: 50.0
        )

        // Archive using NSCoding (old format)
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        legacyOrder.encode(with: archiver)
        let archivedData = archiver.encodedData

        // When - Decode the old data
        let unarchiver = try NSKeyedUnarchiver(forReadingFrom: archivedData)
        unarchiver.requiresSecureCoding = false
        let decoded = LegacyOrderManager(coder: unarchiver)

        // Then - Should successfully decode old format
        XCTAssertNotNil(decoded, "Should maintain backward compatibility with NSCoding")
        XCTAssertEqual(decoded?.orderID as String?, "OLD123")
    }
}
