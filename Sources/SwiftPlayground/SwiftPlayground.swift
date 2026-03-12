// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import GRDB

struct Purchaser: Identifiable, Codable, FetchableRecord, PersistableRecord {
    let id: Int
    var name: String
    var count: Int
    var reservedTable: String

    enum CodingKeys: String, CodingKey {
        case id = "PurchaserID"
        case name = "Name"
        case count = "Count"
        case reservedTable = "ReservedTable"
    }
}



@main
struct SwiftPlayground {
    static func main() {
        let dbPath = "Sources/SwiftPlayground/cafe.db"
        do {
            let dbQueue = try DatabaseQueue(path: dbPath)
            print("Database connection successful")
        }catch{
            print(error)
        }


    }
}
