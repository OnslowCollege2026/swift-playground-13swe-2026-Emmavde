// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import GRDB

/// A reservation at the cafe.
struct Purchaser: Identifiable, Codable, FetchableRecord, PersistableRecord, CustomStringConvertible {
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

    var orderLines: [OrderLine] = []
    var total = 0.0
    var item : Item? = nil
    
        do {
            let dbQueue = try DatabaseQueue(path: dbPath)
            print("Database connection successful")

            try dbQueue.read { database in

                // Dump the schema to make sure we are connected to the correct database file.
                let schema = try database.dumpSchema()
                print(schema)

                // Fetch two Purchaser by ID
                // Fetch one with a known ID value (check your .db file)
                // Fetch one with a made-up ID value and handle the nil case.
                for id in purchaserIds {
                    let purchaser = try Purchaser.fetchOne(database, key: id)
                    if let purchaser {
                        print("Found purchaser: \(purchaser.name)")
                    } else {
                        print("No purchaser with id \(id)")
                    }
                }

                // Fetch one Item and print its detail out. (Hint: make Item conform to CustomStringConvertible)
                guard let item = try Item.fetchOne(database, key: 1) else { return }
                print(item.description)

                // Fetch one Order and print out the Purchaser details related to that order.
                guard let order = try Order.fetchOne(database, key: 1) else { return }
                guard let purchaser = try Purchaser.fetchOne(database, key: order.purchaserId)
                else { return }
                print(purchaser)

                // Fetch all of the OrderLines for a given Order.
                let orderlines = try OrderLine.filter(OrderLine.Columns.orderId == 1).fetchAll(database)

                // For each order line, print their details and tally up the subtotal per line.
                for line in orderlines {
                    var orderString = ""

                    if let item = try Item.fetchOne(database, id: line.itemId) {
                        let subtotal = item.price * Double(line.quantity)
                        total += subtotal
                        orderString = orderString + "\(item)" 
                        orderString = orderString + "subtotal: $\(item.price * Double(line.quantity))"
                    }

                    print(orderString)
                }
                
                item = try Item.fetchOne(database, id: orderlines[0].itemId)

            }

            try dbQueue.write { db in 
                if let item {
                    orderlines[0].quantity = 5 
                }
            }


            try dbQueue.write { database in
                // Fetch all of the OrderLines for a given Order.
                let orderlines = try OrderLine.filter(OrderLine.Columns.orderId == 1).fetchAll(database)
                print(orderlines)

                guard var lineToUpdate = try OrderLine.filter(OrderLine.Columns.orderId == 1 && OrderLine.Columns.itemId == 2).fetchOne(database) else {return}
                print(lineToUpdate)

                // Update one line to change which item was purchased.
                // Calculate the prices in Swift.
                // Update the Order's amount value with the cost of all of the OrderLines.
                
                if !orderlines.contains(where: {$0.itemId == 4 }) {
                    lineToUpdate.itemId = 4
                    try lineToUpdate.update(database)
                }

                var maybeExisting = OrderLine(orderId: lineToUpdate.orderId, itemId: 4, quantity: lineToUpdate.quantity)
                try maybeExisting.save(database)

                // for line in orderlines {
                //     let itemPrice = Item.column
                //     let priceTotal: Double =   * Double(line.quantity)
                // }
            }

        } catch {
            print(error)
        }

    }
}
