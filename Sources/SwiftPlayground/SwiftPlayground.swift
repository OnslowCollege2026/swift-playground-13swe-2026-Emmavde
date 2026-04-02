// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import GRDB

/// A reservation at the cafe.
struct Purchaser: Identifiable, Codable, FetchableRecord, PersistableRecord, CustomStringConvertible
{
    static let databaseTableName = "Purchaser"

    /// The purchaser ID.
    let id: Int

    /// The name of the customer.
    var name: String

    /// The number of people in the party (default 1)
    var count: Int

    /// The name of the reserved table.
    var reservedTable: String?

    var description: String {
        "Purchaser #\(id) \(name) has reserved \(reservedTable ?? "") for a party of \(count)"
    }

    enum CodingKeys: String, CodingKey {
        case id = "PurchaserID"
        case name = "Name"
        case count = "Count"
        case reservedTable = "ReservedTable"
    }
}

/// An item on the menu.
struct Item: Identifiable, Codable, FetchableRecord, PersistableRecord, CustomStringConvertible {
    static let databaseTableName = "Item"

    /// The item id.
    let id: Int

    /// The item name.
    let name: String

    // The price of the item.
    let price: Double

    enum CodingKeys: String, CodingKey {
        case id = "ItemID"
        case name = "Name"
        case price = "Price"
    }

    var description: String {
        return "Item ID: \(id) | Item name: \(name) | Price: \(money(price))"
    }
}

/// An order placed.
struct Order: Identifiable, Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "Order"

    /// The order ID.
    let id: Int

    /// The purchaser ID from the purchaser table.
    let purchaserId: Int

    /// The calculated price of the order.
    let amount: Double

    enum CodingKeys: String, CodingKey {
        case id = "OrderID"
        case purchaserId = "PurchaserID"
        case amount = "Amount"
    }
}

/// A single orderline
struct OrderLine: Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "OrderLine"

    /// The order id from the orders table.
    var orderId: Int

    /// The ID of the item being purchased.
    var itemId: Int

    // The number of the item ordered.
    var quantity: Int

    enum CodingKeys: String, CodingKey {
        case orderId = "OrderID"
        case itemId = "ItemID"
        case quantity = "Quantity"
    }

    enum Columns {
        static let orderId = Column("OrderID")
        static let itemId = Column("ItemID")
    }
}

// Purhcaser IDs to use for testing in Task.
let purchaserIds: [Int] = [
    1, 62,
]

/// Formats a `Double` as currency with exactly two decimal places.
/// - Parameter value: The numeric value to format.
/// - Returns: A string like `$6.50`.
func money(_ value: Double) -> String {
    "$" + String(format: "%.2f", value)
}

@main
struct SwiftPlayground {
    static func main() {
        let dbPath = "Sources/SwiftPlayground/cafe.db"
        guard let dbQueue = try? DatabaseQueue(path: dbPath) else {
            fatalError("Could not open database.")
        }

        var orderLines: [OrderLine] = []
        var total = 0.0
        var item: Item? = nil

        do {

            try dbQueue.read { db in
                try db.dumpSchema()

                // Fetch two Purchaser by ID
                // Fetch one with a known ID value (check your .db file)
                // Fetch one with a made-up ID value and handle the nil case.
                for id in purchaserIds {
                    let purchaser = try Purchaser.fetchOne(db, key: id)
                    if let purchaser {
                        print("Found purchaser: \(purchaser.name)")
                    } else {
                        print("No purchaser with id \(id)")
                    }
                }

                // Fetch one Item and print its detail out. (Hint: make Item conform to CustomStringConvertible)
                guard let testItem = try Item.fetchOne(db, key: 1) else { return }
                print(testItem.description)

                // Fetch one Order and print out the Purchaser details related to that order.
                if let order = try Order.fetchOne(db, key: 1),
                    let purchaser = try Purchaser.fetchOne(db, key: order.purchaserId)
                {

                    print(purchaser.description)

                    // Fetch all of the OrderLines for the given Order.
                    let orderlines = try OrderLine.filter(OrderLine.Columns.orderId == order.id)
                        .fetchAll(db)

                    // For each order line, print their details and tally up the subtotal per line.
                    for line in orderlines {
                        var orderString = ""

                        if let item = try Item.fetchOne(db, id: line.itemId) {
                            let subtotal = item.price * Double(line.quantity)
                            total += subtotal
                            orderString = orderString + "\(item)"
                            orderString =
                                orderString + " subtotal: $\(item.price * Double(line.quantity))"
                        }

                        print(orderString)
                    }
                    item = try Item.fetchOne(db, id: orderlines[0].itemId)
                }
            }

        } catch {
            print(error)
        }

        if let item {

            do {
                try dbQueue.write { db in

                    let newQuantity = 5
                    orderLines[0].quantity = newQuantity
                    let currentSubtotal = item.price * Double(orderLines[0].quantity)
                    let newSubtotal = item.price * Double(newQuantity)
                    total = total - currentSubtotal
                    total = total + newSubtotal
                    try orderLines[0].update(db)
                }
            } catch {
                print(error)
            }
        }
    }
}
