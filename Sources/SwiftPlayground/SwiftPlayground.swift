// Assessment Task:
// school library book borrowing system
// Created 22/04/2026
// Emma van den Eijkhoff

import Foundation
import GRDB

/// A Borrower who takes out loans. 
struct Borrower: Identifiable, Codable, FetchableRecord, PersistableRecord {
    /// The Borrower ID
    let id: Int

    /// The Borrower's name
    let name: String

    /// The number of loans the borrower currently has out/unreturned.
    let currentLoans: Int

}

@main
struct SwiftPlayground {
    static func main() {
        let dbPath = "./Sources/SwiftPlayground/library.db"
        guard let dbQueue = try? DatabaseQueue(path: dbPath) else {
            fatalError("Could not open database.")
        }

        do {
            try dbQueue.read { db in
                try db.dumpSchema()
            }
        } catch { print("Error dumping database schema") }

    }
}
