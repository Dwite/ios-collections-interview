import Foundation

// MARK: - Task 7: Objective-C to Swift Migration

/// Migrate this legacy Objective-C-style code to modern Swift patterns
///
/// Requirements:
/// - Replace completion handlers with async/await
/// - Use Swift native types instead of Foundation types (String vs NSString)
/// - Maintain backward compatibility for existing data
/// - All tests should pass
///
/// Legacy implementation (Objective-C style):

class LegacyOrderManager: NSObject, NSCoding {

    var orderID: NSString
    var customerID: NSString
    var amount: NSNumber
    var metadata: NSDictionary?

    init(orderID: String, customerID: String, amount: Double, metadata: [String: Any]? = nil) {
        self.orderID = orderID as NSString
        self.customerID = customerID as NSString
        self.amount = NSNumber(value: amount)
        self.metadata = metadata as NSDictionary?
        super.init()
    }

    required init?(coder: NSCoder) {
        self.orderID = coder.decodeObject(forKey: "orderID") as? NSString ?? ""
        self.customerID = coder.decodeObject(forKey: "customerID") as? NSString ?? ""
        self.amount = coder.decodeObject(forKey: "amount") as? NSNumber ?? 0
        self.metadata = coder.decodeObject(forKey: "metadata") as? NSDictionary
        super.init()
    }

    func encode(with coder: NSCoder) {
        coder.encode(orderID, forKey: "orderID")
        coder.encode(customerID, forKey: "customerID")
        coder.encode(amount, forKey: "amount")
        coder.encode(metadata, forKey: "metadata")
    }

    func fetchOrderDetails(completion: @escaping ([String: Any]?, NSError?) -> Void) {
        DispatchQueue.global().async {
            // Simulate network call
            let result: [String: Any] = [
                "status": "completed",
                "timestamp": Date().timeIntervalSince1970
            ]
            completion(result, nil)
        }
    }

    @objc func updateAmount(_ newAmount: NSNumber) {
        self.amount = newAmount
        NotificationCenter.default.post(name: NSNotification.Name("OrderDidUpdate"), object: nil)
    }
}

// TODO: Migrate to modern Swift:
// - Use async/await instead of completion handlers
// - Use Swift String/Double instead of NSString/NSNumber
// - Use Combine or proper observer pattern instead of NotificationCenter
