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
    // var currentLoans: Int {
    //     return //
    // }

    enum CodingKeys: String, CodingKey {
        case id = "Borrower ID"
        case name = "Name"
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

    enum CodingKeys: String, CodingKey {
        case id = "Book ID"
        case title = "Title"
        case author = "Author"
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

func showActions() {
    print(
        """
        Choose an action from the menu:
        ----------------------------------
        1. View the book catalouge (see book availability).
        2. add a book
        3. delete a book (make permanantly unavaialble? add property/column (exsists))

        4. Borrow a book. (add loan)
        5. return a book. (change returned property of loan)

        6. View borrowers list
        7. Add a borrower
        8. edit a borrower's details.
        """)
}

@main
struct SwiftPlayground {
    static func main() {

        // An array of all of the books in the library, both available and on loan.
        var allBooks: [Book] = []

        // An array of all of the members in the system.
        var allMembers: [Borrower] = []

        // An array of all recorded loans.
        var allLoans: [Loan] = []

        let dbPath = "./Sources/SwiftPlayground/library.db"
        guard let dbQueue = try? DatabaseQueue(path: dbPath) else {
            fatalError("Could not open database.")
        }

        do {
            try dbQueue.read { db in
                // try db.dumpSchema()
                allBooks = try Book.fetchAll(db)
                allMembers = try Borrower.fetchAll(db)
                allLoans = try Loan.fetchAll(db)

            }
        } catch { print("Error: \(error)") }

            for book in allBooks {
                let available = !allLoans.contains {$0.bookId == book.id && $0.returned == 0}

        }
    }
}
