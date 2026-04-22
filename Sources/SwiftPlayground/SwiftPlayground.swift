// Assessment Task:
// school library book borrowing system
// Created 22/04/2026
// Emma van den Eijkhoff

import Foundation
import GRDB

/// A Borrower who takes out loans. 
struct Borrower: Identifiable, Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "Borrower"

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
    static let databaseTableName = "Book"

    /// The Book ID.
    let id: Int

    /// The Books's title.
    let title: String

    /// The Book's author.
    let author: String

    /// Whether the book is avialable or not. 0 = false (not available), 1 = true (available)

    var available: Bool {
        // return Loans.returned.at book ID !contains(0)
        return false
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "Book ID"
        case title = "Title"
        case author = "Author"
        // case available = "Available"
    }
}

/// A single loan record of a book. 
struct Loan: Identifiable, Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "Loan"

    /// The Loan ID.
    let id: Int

    /// The Borrower ID from the Borrowers table.
    let borrowerId: Int

    /// The Book ID from the Borrowers table.
    let bookId: Int

    /// The agreed number of days the book was loaned for.
    let loanPeriod: Int 

    /// Whether or not the book was returned. 0 = false (not returned), 1 = true (returned)
    let returned: Int

    enum CodingKeys: String, CodingKey {
        case id = "Loan ID"
        case borrowerId = "Borrower ID"
        case bookId = "Book ID"
        case loanPeriod = "Loan Period"
        case returned = "Returned"
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




        print("""
        Library Borrowing system:
        ----------------------------
        Welcome to the library borrowing system. 
        """)

        print()

    }
}
