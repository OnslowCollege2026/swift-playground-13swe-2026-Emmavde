// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import GRDB

@main
struct SwiftPlayground {
    static func main() {
        let dbPath = "./Sources/SwiftPlayground/cafe.db"
        guard let dbQueue = try? DatabaseQueue(path: dbPath) else {
            fatalError("Could not open database.")
        }
    }
}


struct Purchaser: Idenifiable, 
