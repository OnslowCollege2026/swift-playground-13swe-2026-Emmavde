// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import GRDB

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

    /// 
    static func fetchPurchaser (with minimumTableCount: Int) -> [Purchaser] {
        
    }
}

@main
struct SwiftPlayground {
    static func main() {
        let dbPath = "./Sources/SwiftPlayground/cafe.db"
        guard let dbQueue = try? DatabaseQueue(path: dbPath) else {
            fatalError("Could not open database.")
        }

        var purchaser: Purchaser? = nil

        do {
            try dbQueue.read { db in
                // try db.dumpSchema()
                purchaser = try Purchaser.fetchOne(db, key: 1)
                print(purchaser)
            }
        } catch {
            print("Error: \(error)")
        }

        if var purchaser {
            purchaser.count = 5000
            do {
                try dbQueue.write { db in
                    try purchaser.update(db)
                }
            } catch {
                print("Error 2: \(error)")
            }
        }
    }

}
