// Assessment Task:
// school library book borrowing system
// Created 22/04/2026
// Emma van den Eijkhoff

import Foundation
import GRDB

/// A Borrower who takes out loans.
struct Borrower: Identifiable {
    static let databaseTableName = "Borrower"

    /// The Borrower ID.
    let id: Int

    /// The Borrower's name.
    var name: String
}

/// A book that can be loaned.
struct Book: Identifiable {

    /// The Book ID.
    let id: Int

    /// The Books's title.
    let title: String

    /// The Book's author.
    let author: String

    ///
    ///
    /// - Parameters:
    ///   - book:
    ///   - loans:
    /// - Returns:
    func isAvailable(book: Book, loans: [Loan]) -> Bool {
        !loans.contains(where: { $0.bookId == book.id && !$0.returned })
    }

}

/// A single loan record of a book.
struct Loan: Identifiable {
    static let databaseTableName = "Loan"

    /// The Loan ID.
    let id: Int

    /// The Borrower ID from the Borrowers table.
    let borrowerId: Int

    /// The Book ID from the Borrowers table.
    let bookId: Int

    /// The agreed number of days the book was loaned for.
    let loanPeriod: Int

    /// Whether or not the book was returned.
    var returned: Bool
}

/// A single option on the action menu option.
struct menuOption {
    // The option's number it is selected by.
    let optionNumber: Int

    // The description of what action it performs.
    let description: String

    // The function that option calls.
    let action: ()
}

let actionOptions: [menuOption] = [
    menuOption(optionNumber: 1, description: "View books", action: ()),
    menuOption(optionNumber: 2, description: "Add book", action: ()),
    menuOption(optionNumber: 3, description: "Delete book", action: ()),
    menuOption(optionNumber: 4, description: "Borrow book", action: ()),
    menuOption(optionNumber: 5, description: "return book", action: ()),
    menuOption(optionNumber: 6, description: "View borrowers", action: ()),
    menuOption(optionNumber: 7, description: "Add borrower", action: ()),
    menuOption(optionNumber: 8, description: "Edit borrower", action: ()),
]

// Some books to add to the library for testing.
let preSetBooks: [Book] = [
    Book(id: 1, title: "1984", author: "George Orwell"),
    Book(id: 2, title: "The Ultimate Guide to Swordfish", author: "Victoria Chew"),
    Book(id: 3, title: "The Hobbit", author: "J.R.R. Tolkien"),
    Book(id: 4, title: "Pride and Prejudice", author: "Jane Austen"),
    Book(id: 5, title: "A Study in Scarlet", author: "Sir Arthur Conan Doyle"),
    Book(id: 6, title: "The Hitchhiker's Guide to the Galaxy", author: "Douglas Adams"),
    Book(id: 7, title: "The Lord of the Rings", author: "J.R.R. Tolkien"),
    Book(id: 8, title: "Animal Farm", author: "George Orwell"),
    Book(id: 9, title: "Holes", author: "Louis Sachar"),
    Book(id: 10, title: "The 3 Body Problem", author: "Cixin Liu"),
]

// SOme borrower data to add to the library for testing.
let preSetBorrowers: [Borrower] = [
    Borrower(id: 1, name: "Alice Johnson"),
    Borrower(id: 2, name: "Bo-Katan Kryze"),
    Borrower(id: 3, name: "Charlotte Smith"),
    Borrower(id: 4, name: "Daniel Lee"),
    Borrower(id: 5, name: "Gamora"),
    Borrower(id: 6, name: "Gandalf"),
]

// Some past loan data to add to the library for testing.
let preSetLoans: [Loan] = [
    Loan(id: 1, borrowerId: 1, bookId: 2, loanPeriod: 14, returned: false),
    Loan(id: 2, borrowerId: 3, bookId: 4, loanPeriod: 7, returned: false),
    Loan(id: 3, borrowerId: 2, bookId: 7, loanPeriod: 21, returned: false),
    Loan(id: 4, borrowerId: 4, bookId: 3, loanPeriod: 10, returned: true),
]

func showActions() {
    print(
        """
        \n------------------------------------
        Choose an action from the menu:
        ------------------------------------
        """)
    for option in actionOptions {
        print("\(option.optionNumber). \(option.description)")
    }
}

func viewBooks() {

}

@main
struct SwiftPlayground {
    static func main() {

        // All of the books, available and on loan, in the library.
        var books: [Book] = preSetBooks

        // All of the borrowers/members of the library
        var borrowers: [Borrower] = preSetBorrowers

        // All of the past loans from the library.
        var loans: [Loan] = preSetLoans

        var running: Bool = true
        while running {
            showActions()
            print("\nEnter option number, or 'done' to finish.): ", terminator: "")

            guard let optionInput: String = readLine()
            else {
                print("Invalid input")
                continue
            }

            if optionInput.lowercased() == "done" {
                running = false
            }

            else {
                if let optionNumber = Int(optionInput) {

                }

                print("Invalid. Please enter a number or 'done'.")
            }
        }
    }
}
