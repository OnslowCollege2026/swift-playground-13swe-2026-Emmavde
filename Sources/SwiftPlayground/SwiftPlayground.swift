// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

struct Video: Identifiable {
    let id: UUID
    let title: String
    let dailyRate: Double
}

struct Customer: Identifiable {
    let id: UUID
    let name: String
    let address: String
}

struct VideoRental {
    let videoID: Video.ID
    let customerID: Customer.ID
    let dayIssued: Int
    let dayToReturn: Int
    let wasReturned: Bool
}

struct Receipt {
    let videoID: Video.ID
    let customerID: Customer.ID
    let pricePaid: Double
    let overdueFeeCharged: Bool
}

// Create CustomerBill with the required fields and protocol conformances.
// Properties: customer: Customer, receipt: Receipt — it accepts the actual objects as arguments, not just the ID
// Protocol conformance: CustomStringConvertible, Equatable, Sortable
struct CustomerBill: CustomStringConvertible, Equatable, Comparable {
    var customer: Customer
    var receipt: Receipt
    var description: String {
        """
        Kia ora \(customer.name),

        Our records show that \(videos.first(where: {$0.id == receipt.videoID})?.title ?? "") was overdue.
        Base rental paid: \(money(receipt.pricePaid))
        Overdue fee now due: \(money(overdueFee))

        Please pay this amount at your earliest convenience.
        Store Billing Team
        """
    }

    static func == (lhs: CustomerBill, rhs: CustomerBill) -> Bool {
        return (lhs.customer.name == lhs.customer.name)
    }

    static func < (lhs: CustomerBill, rhs: CustomerBill) -> Bool {
            (lhs.receipt.pricePaid) + overdueFee < (rhs.receipt.pricePaid) + overdueFee
    }
}


let videos: [Video] = [
    Video(id: UUID(), title: "The Matrix", dailyRate: 4.50),
    Video(id: UUID(), title: "Toy Story", dailyRate: 3.00),
    Video(id: UUID(), title: "Spirited Away", dailyRate: 4.00),
    Video(id: UUID(), title: "Interstellar", dailyRate: 5.00),
    Video(id: UUID(), title: "Moana", dailyRate: 3.50)
]

let customers: [Customer] = [
    Customer(id: UUID(), name: "Aroha Ngata", address: "14 Kowhai Street"),
    Customer(id: UUID(), name: "Liam Patel", address: "8 Tui Avenue"),
    Customer(id: UUID(), name: "Mia Thompson", address: "22 Rimu Road"),
    Customer(id: UUID(), name: "Noah Wiremu", address: "3 Pukeko Lane"),
    Customer(id: UUID(), name: "Eva Chen", address: "11 Nikau Place")
]

let rentals: [VideoRental] = [
    VideoRental(videoID: videos[0].id,
                customerID: customers[0].id,
                dayIssued: 1, dayToReturn: 3,
                wasReturned: true),
    VideoRental(videoID: videos[1].id,
                customerID: customers[1].id,
                dayIssued: 2, dayToReturn: 4,
                wasReturned: false),
    VideoRental(videoID: videos[2].id,
                customerID: customers[2].id,
                dayIssued: 2, dayToReturn: 5,
                wasReturned: true),
    VideoRental(videoID: videos[3].id,
                customerID: customers[3].id,
                dayIssued: 3, dayToReturn: 6,
                wasReturned: false),
    VideoRental(videoID: videos[4].id,
                customerID: customers[4].id,
                dayIssued: 4, dayToReturn: 6,
                wasReturned: true)
]

let overdueFee: Double = 2.0

/// Formats a Double as currency to 2dp.
func money(_ value: Double) -> String {
    "$" + String(format: "%.2f", value)
}

@main
struct SwiftPlayground {
    static func main() {

// Task A
// Map rentals to receipts, then print receipts.

// Complete the following:

// Use map to build a [Receipt] from rentals.
// Use a for loop to print each receipt in this format:
// Receipt | Customer: <name> | Video: <title> | Base: $<price> | Overdue: <Yes/No>

// Format money to 2 decimal places.

        let receiptList: [Receipt] = rentals.map { rental in 
        Receipt(
            videoID: rental.videoID, 
            customerID: rental.customerID, 
            pricePaid: (videos.first{$0.id == rental.videoID})?.dailyRate ?? 0.0 * Double(rental.dayToReturn - rental.dayIssued), 
            overdueFeeCharged: !(rental.wasReturned)
            )
        }

        for receipt in receiptList {
            let customerName = customers.first(where: {$0.id == receipt.customerID})?.name ?? ""
            let videoTitle = videos.first(where: {$0.id == receipt.videoID})?.title ?? ""
            var overdue: String {
                return if receipt.overdueFeeCharged {"yes"} else {"No"}
            }
            
            print("Receipt | Customer: \(customerName) | Video: \(videoTitle) | Base: \(money(receipt.pricePaid)) | Overdue: \(overdue)")
        }

        // Use filter to keep only receipts where overdueFeeCharged == true.
        // Use a loop to print a mailing list in this format:
        // Send overdue notice to: <customer name>, <address>

        // Use the customers data (via customerID) to find addresses.

        let overdueReceipts = receiptList.filter{$0.overdueFeeCharged}

        for receipt in overdueReceipts {
            let customerName: String = customers.first(where: {$0.id == receipt.customerID})?.name ?? ""
            let address: String = customers.first(where: {$0.id == receipt.customerID})?.address ?? ""
            print("Send overdue notice to: \(customerName), \(address)")
        }

        // Use reduce on the overdueReceipts array.
        // Add $2.00 for each overdue receipt.
        // Print the final total in this format:
        // Total overdue fees collected: $<amount>

        let totalFees: Double = overdueReceipts.reduce(0.0) { total, _ in total + overdueFee }
        print("Total overdue fees collected: \(money(totalFees))")

        // Use map to convert overdue receipts into [CustomerBill].
        // Sort the bills array from highest fee to lowest using .sorted().reversed().
        // Print only the first bill to verify your description output.

        let customerBills: [CustomerBill] = overdueReceipts.compactMap { receipt in
            guard let customer = customers.first(where: { $0.id == receipt.customerID }) else {
                return nil
            }
            return CustomerBill(customer: customer, receipt: receipt)
        }
    }
}
