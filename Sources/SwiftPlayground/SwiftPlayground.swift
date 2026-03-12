// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import GRDB

/// A reservation at the cafe.
struct Purchaser: Identifiable, Codable, FetchableRecord, PersistableRecord {
    /// The purchaser ID.
    let id: Int

    /// The name of the customer.
    var name: String

    /// The number of people in the party (default 1)
    var count: Int

    /// The name of the reserved table.
    var reservedTable: String

    enum CodingKeys: String, CodingKey {
        case id = "PurchaserID"
        case name = "Name"
        case count = "Count"
        case reservedTable = "ReservedTable"
    }
}

/// An item on the menu. 
struct Item: Identifiable, Codable, FetchableRecord, PersistableRecord {
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
}

/// An order placed.
struct order: Identifiable, Codable, FetchableRecord, PersistableRecord {
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
struct orderLine: Codable, FetchableRecord, PersistableRecord {
    /// The order id from the orders table.
    let orderId: Int

    /// The ID of the item being purchased.
    let itemId: Int

    // The number of the item ordered.
    let quantity: Int
}




@main
struct SwiftPlayground {
    static func main() {
        let dbPath = "Sources/SwiftPlayground/cafe.db"
        do {
            let dbQueue = try DatabaseQueue(path: dbPath)
            print("Database connection successful")


            try dbQueue.read { database in
                // Dump the schema to make sure we are connected to the correct database file.
                try database.dumpSchema()
                // Find a customer at the window seat
                let windowSitter = Purchaser.filter(key: [
                    "ReservedTable": "Window Seat"
                ])
                print(windowSitter)
            }

        }catch{
            print(error)
        }


    }
}
