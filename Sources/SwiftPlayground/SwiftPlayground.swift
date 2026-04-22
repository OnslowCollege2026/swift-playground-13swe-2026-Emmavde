// Assessment Task:
// school library book borrowing system
// Created 22/04/2026
// Emma van den Eijkhoff

import Foundation
import GRDB

/// A Borrower who takes out loans. 
struct Borrower: Identifiable, Codable, FetchableRecord, PersistableRecord {
    /// The Borrower ID.
    let id: Int

    /// The Borrower's name.
    let name: String

    /// The number of loans the borrower currently has out/unreturned.
    let currentLoans: Int

    enum CodingKeys: String, CodingKey {
        case id = "Borrower ID"
        case name = "Name"
        case currentLoans = "Current Loans"
    }
}

/// A book that can be loaned. 
struct Book: Identifiable, Codable, FetchableRecord, PersistableRecord {
    /// The Book ID.
    let id: Int

    /// The Books's title.
    let title: String

    /// The Book's author.
    let author: String

    /// Whether the book is avialable or not. 0 = false (not available), 1 = true (available)

    // var available: Int {
    //     // return Loans.returned.at book ID !contains(0)
    // }
    


    enum CodingKeys: String, CodingKey {
        case id = "Book ID"
        case title = "Title"
        case author = "Author"
        // case available = "Available"
    }
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
