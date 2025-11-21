import Foundation

// MARK: - Task 4.2: Actors

/// Refactor BankAccount to make it production ready

protocol PaymentGateway {
    func authorize(amount: Int, from account: BankAccount) async throws
}

actor BankAccount {
    let id: UUID
    private var balance: Int
    private let paymentGateway: PaymentGateway

    init(balance: Int, paymentGateway: PaymentGateway) {
        self.id = UUID()
        self.balance = balance
        self.paymentGateway = paymentGateway
    }

    func deposit(amount: Int) {
        balance += amount
    }
    
    func getBalance() -> Int { balance }
    
    func transfer(amount: Int, to other: BankAccount) async throws {
        guard balance >= amount else {
            print("❌ [\(self)] Insufficient funds")
            throw TransferError.insufficientFunds
        }
        
        try await paymentGateway.authorize(amount: amount, from: self)
        balance -= amount
        await other.deposit(amount: amount)
    }
}

enum TransferError: Error, CustomStringConvertible {
    case insufficientFunds
    case paymentAuthorizationFailed
    
    var description: String {
        switch self {
        case .insufficientFunds:
            return "Insufficient funds"
        case .paymentAuthorizationFailed:
            return "Payment authorization failed"
        }
    }
}

// Fake payment gateway that simulates an external suspension point
struct MockPaymentGateway: PaymentGateway {
    func authorize(amount: Int, from account: BankAccount) async throws {
        print("🔄 Authorizing \(amount) from account \(account.id)...")
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds suspend
        print("✅ Authorization complete for amount \(amount).")
    }
}
