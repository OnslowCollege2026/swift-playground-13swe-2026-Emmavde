// Assessment Task:
// school library book borrowing system
// Created 22/04/2026
// Emma van den Eijkhoff

import Foundation
import GRDB

/// A Borrower who takes out loans.
struct Borrower: Identifiable, CustomStringConvertible {
    static let databaseTableName = "Borrower"

    /// The Borrower ID.
    let id: Int

    /// The Borrower's name.
    var name: String

    var description: String {
        "ID: \(id) | Name: \(name) "
    }

    func currentLoans(loans: [Loan]) -> Int {
        loans.reduce(0) {$0 + (($1.borrowerId == id && !$1.returned) ? 1 : 0)}
    }
}

/// A book that can be loaned.
struct Book: Identifiable, CustomStringConvertible {

    /// The Book ID.
    let id: Int

    /// The Books's title.
    let title: String

    /// The Book's author.
    let author: String

    // Whether or not the book stilll exists in the libraries catalouge.
    var exists: Bool

    var description: String {
        "ID: \(id) | Title: \(title) | Author: \(author)"
    }

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
}

/// Get user input in the from of a string.
///
/// - Parameter prompt: The prompt displayed to the user.
/// - Returns: The string the user inputted.
func input(forString prompt: String) -> String? {
    print(prompt, terminator: " ")
    let userInput: String? = readLine()
    return userInput
}
/// Get user input in the form of an integer.
///
/// - Parameter prompt:
/// - Returns:
func input(forInt prompt: String) -> Int? {
    if let userInput = input(forString: prompt), let intInput = Int(userInput) {
        return intInput
    } else {
        return nil
    }

}

/// Print the menu of user actions.
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
///
///
/// - Parameters:
///   - books:
///   - loans:
func viewBooks(books: [Book], loans: [Loan]) {
    print(
        """
        A. View all books.
        B. View available books.
        """)

    var looping: Bool = true
    var filteredBooks: [Book] = []

    while looping {
        guard let optionInput: String = input(forString: "Please enter the option letter: ") else {
            print("Invalid")
            continue
        }

        if optionInput.lowercased() == "a" {
            looping = false
            filteredBooks = books.filter({ $0.exists })
        } else if optionInput.lowercased() == "b" {
            looping = false
            filteredBooks = books.filter({ $0.exists && $0.isAvailable(book: $0, loans: loans) })
        } else {
            print("Invalid. Enter 'a' or 'b'.")
        }
    }

    print(
        """
        \nBook list:
        ----------------
        """)

    for book in filteredBooks {
        var availability: String = "Not available"
        if book.isAvailable(book: book, loans: loans) {
            availability = "Available"
        }
        print("\(book) | \(availability)")
    }

}

///
/// - Parameter borrowers:
func viewBorrowers(borrowers: [Borrower], loans: [Loan]) {
    print(
        """
        Borrowers list:
        ---------------------
        """)
    for borrower in borrowers {
        let currentLoans: Int = borrower.currentLoans(loans: loans)
        print("\(borrower) | \(currentLoans) books on loan.")
    }
}

///
/// - Parameter books:
func addBooks(to books: inout [Book]) {
    print(
        """
        Add a book:
        ------------------
        """)

    let id = (books.map { $0.id }.max() ?? 0) + 1
    var author: String = ""
    var title: String = ""

    while true {
        guard let titleInput = input(forString: "Enter book title: "), titleInput.count >= 1 else {
            print("Please enter a title.")
            continue
        }
        title = titleInput
        break
    }

    while true {
        guard let authorInput = input(forString: "Enter Author's name: "), authorInput.count >= 1
        else {
            print("Please enter an author.")
            continue
        }
        author = authorInput
        break
    }

    let newBook: Book = Book(id: id, title: title, author: author, exists: true)
    books.append(newBook)
    print("\(newBook) was added")

}

///
/// - Parameter books:
func removeBook(from books: inout [Book]) {
    print(
        """
        Remove a book: (This will not remove the book from loan history.)
        -------------------------------------------------------------------
        """)

    while true {
        guard let idToRemove = input(forInt: "Enter the ID number of the book to delete: "),
            idToRemove > 0
        else {
            print("Please enter a valid ID number.\n")
            continue
        }

        if var IndexToRemove: Int = (books.firstIndex(where: { $0.id == idToRemove && $0.exists }))
        {
            books[IndexToRemove].exists = false
            print("\(books[IndexToRemove]) has been removed from the library.")

        } else {
            print("Book does not exist or has already been removed.")
        }
        return
    }
}

func borrowBook(from books: [Book], to loans: inout [Loan], borrowers: [Borrower]) {
    print("""
    \nBorrow a book:
    -------------------
    """)

    
}

func returnBook() {
    print("returnBook() ran.")
}

func addBorrower(to borrowers: inout [Borrower]) {

    print(
        """
        Register a borrower:
        -----------------------
        """)

    let id = (borrowers.map { $0.id }.max() ?? 0) + 1
    var name: String = ""

    while true {
        guard let nameInput = input(forString: "Enter the borrower's name: "), nameInput.count >= 1
        else {
            print("Please enter a name.")
            continue
        }
        name = nameInput
        break
    }

    let newBorrower: Borrower = Borrower(id: id, name: name)
    borrowers.append(newBorrower)
    print("\(newBorrower) was added")

}

func editBorrower(from borrowers: inout [Borrower]) {
    print(
        """
        Edit borrower details:
        -------------------------
        """)

    var idToEdit: Int = 0

    while true {
        guard let idInput = input(forInt: "Enter the borrower's ID number: "), idInput > 0 else {
            print("Please enter a valid ID number.\n")
            continue
        } 
        idToEdit = idInput
        break
    }

        if let IndexToedit: Int = (borrowers.firstIndex(where: { $0.id == idToEdit })) {
            if let newName: String = input(forString: "Enter the borrower's updated name: ") {
                borrowers[IndexToedit].name = newName
            }
        } else {
            print("There is no borrower with that ID.")
        }

}

func searchBooks() {
    print("searchBooks() ran")
}

func searchBorrowers() {
    print("searchBorrowers() ran")
}

// The different actions dispalyed in the option menu.
let actionOptions: [menuOption] = [
    menuOption(optionNumber: 1, description: "View books"),
    menuOption(optionNumber: 2, description: "Add a book"),
    menuOption(optionNumber: 3, description: "Remove a book"),
    menuOption(optionNumber: 4, description: "Borrow a book"),
    menuOption(optionNumber: 5, description: "return a book"),
    menuOption(optionNumber: 6, description: "View borrowers"),
    menuOption(optionNumber: 7, description: "Register a borrower"),
    menuOption(optionNumber: 8, description: "Edit a borrower's details"),
    menuOption(optionNumber: 9, description: "Search books"),
    menuOption(optionNumber: 10, description: "Search Borrowers"),
]

// Some books to add to the library for testing.
let preSetBooks: [Book] = [
    Book(id: 1, title: "1984", author: "George Orwell", exists: true),
    Book(id: 2, title: "The Ultimate Guide to Swordfish", author: "Victoria Chew", exists: true),
    Book(id: 3, title: "The Hobbit", author: "J.R.R. Tolkien", exists: true),
    Book(id: 4, title: "Pride and Prejudice", author: "Jane Austen", exists: true),
    Book(id: 5, title: "A Study in Scarlet", author: "Sir Arthur Conan Doyle", exists: true),
    Book(
        id: 6, title: "The Hitchhiker's Guide to the Galaxy", author: "Douglas Adams", exists: true),
    Book(id: 7, title: "The Lord of the Rings", author: "J.R.R. Tolkien", exists: true),
    Book(id: 8, title: "Animal Farm", author: "George Orwell", exists: true),
    Book(id: 9, title: "Holes", author: "Louis Sachar", exists: true),
    Book(id: 10, title: "The 3 Body Problem", author: "Cixin Liu", exists: true),
]

// Some borrower data to add to the library for testing.
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

            guard
                let optionInput: String = input(
                    forString: "\nEnter option number, or 'done' to finish: ")
            else {
                print("Invalid input")
                continue
            }

            if optionInput.lowercased() == "done" {
                running = false
            }

            else {
                if let optionNumber = Int(optionInput) {

                    switch optionNumber {
                    case 1: viewBooks(books: books, loans: loans)
                    case 2: addBooks(to: &books)
                    case 3: removeBook(from: &books)
                    case 4: borrowBook()
                    case 5: returnBook()
                    case 6: viewBorrowers(borrowers: borrowers, loans: loans)
                    case 7: addBorrower(to: &borrowers)
                    case 8: editBorrower(from: &borrowers)
                    case 9: searchBooks()
                    case 10: searchBorrowers()
                    default: print("Invalid. Please enter a number from the menu, or 'done'.")
                    }
                } else {
                    print("Invalid. Please enter a number from the menu, or 'done'.")
                }
            }
        }
    }
}
