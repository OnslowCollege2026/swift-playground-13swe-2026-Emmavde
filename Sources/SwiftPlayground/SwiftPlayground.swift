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
        loans.reduce(0) { $0 + (($1.borrowerId == id && !$1.returned) ? 1 : 0) }
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

    func loanDetails(books: [Book], borrowers: [Borrower]) -> String {
        let title: String = books.first(where: { $0.id == bookId })?.title ?? ""
        let borrowerName: String = borrowers.first(where: { $0.id == borrowerId })?.name ?? ""
        return
            ("Loan ID: \(id) | '\(title)' loaned to \(borrowerName) for \(loanPeriod) days. \(returned ? "" : "Not") Returned. ")
    }
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

func input(forNotNullString prompt: String) -> String {
    while true {
        print(prompt, terminator: " ")
        if let userInput: String = readLine(), userInput.count > 0 {
            return userInput
        }
        print("Invalid. Input cannot be empty.")
    }
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

///
/// - Parameter prompt:
/// - Returns:
func input(loopUntilPositiveIntGiven prompt: String) -> Int {
    while true {
        if let userInput = input(forInt: prompt), userInput > 0 {
            return userInput
        }
        print("Invalid. Please enter a positive integer.")
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

    var filteredBooks: [Book] = []
    var looping: Bool = true
    while looping {

        let optionInput: String = input(forNotNullString: "Please enter the option letter: ")

        if optionInput.lowercased() == "a" {
            filteredBooks = books.filter({ $0.exists })
            looping = false
        } else if optionInput.lowercased() == "b" {
            filteredBooks = books.filter({ $0.exists && $0.isAvailable(book: $0, loans: loans) })
            looping = false
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
    let title: String = input(forNotNullString: "Enter book title: ")
    let author: String = input(forNotNullString: "Enter Author's name: ")

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

        if let IndexToRemove: Int = (books.firstIndex(where: { $0.id == idToRemove && $0.exists }))
        {
            books[IndexToRemove].exists = false
            print("\(books[IndexToRemove]) has been removed from the library.")

        } else {
            print("Book does not exist or has already been removed.")
        }
        return
    }
}

///
/// - Parameters:
///   - books:
///   - borrowers:
///   - loans:
func borrowBook(from books: [Book], from borrowers: [Borrower], to loans: inout [Loan]) {
    print(
        """
        \nBorrow a book:
        -------------------
        """)

    if books.filter({ $0.isAvailable(book: $0, loans: loans) }).isEmpty {
        print("Unfortunately all books are on loan. ")
    } else {

        let loanId: Int = (loans.map { $0.id }.max() ?? 0) + 1
        var borrowerId: Int = 0
        var bookId: Int = 0
        var loanPeriod: Int = 0

        while true {
            let id: Int = input(loopUntilPositiveIntGiven: "Enter your Borrower ID: ")
            if borrowers.contains(where: { $0.id == id }) {
                borrowerId = id
                break
            } else {
                print("No borrower of this ID exists.")
            }
        }

        while true {
            let id: Int = input(
                loopUntilPositiveIntGiven: "Enter the ID of the book you wish to borrow: ")
            if let bookToBorrow = books.first(where: { $0.id == id }),
                bookToBorrow.exists,
                bookToBorrow.isAvailable(book: bookToBorrow, loans: loans)
            {
                bookId = id
                break
            } else {
                print("No book of this ID exists, or the book is currently unavialable.")
            }
        }

        while true {
            loanPeriod = input(
                loopUntilPositiveIntGiven: """
                    How many days do you wish to loan the book? (maximum loan period is \(maxLoanPeriod) days): 
                    """)

            if loanPeriod > 0 && loanPeriod <= maxLoanPeriod {
                break
            } else {
                print("The maximum loan period is \(maxLoanPeriod) days.")
            }
        }

        let newLoan: Loan = Loan(
            id: loanId, borrowerId: borrowerId, bookId: bookId, loanPeriod: loanPeriod,
            returned: false)

        loans.append(newLoan)
        print("\n\(newLoan.loanDetails(books: books, borrowers: borrowers))")
    }

}

///
/// - Parameters:
///   - loans:
///   - books:
func returnBook(to loans: inout [Loan], books: [Book], borrowers: [Borrower]) {
    print(
        """
        Return a book:
        --------------------
        """)

    let id = input(loopUntilPositiveIntGiven: "Enter the ID of the book you are returning: ")

    if let indexToedit: Int = loans.firstIndex(where: { $0.bookId == id && !$0.returned }) {
        loans[indexToedit].returned = true
        print(loans[indexToedit].loanDetails(books: books, borrowers: borrowers))
    } else {
        print("This book is not on loan, or does not exist.")
    }
}

///
/// - Parameter borrowers:
func addBorrower(to borrowers: inout [Borrower]) {

    print(
        """
        Register a borrower:
        -----------------------
        """)

    let id = (borrowers.map { $0.id }.max() ?? 0) + 1
    let name: String = input(forNotNullString: "Enter the borrower's name: ")

    let newBorrower: Borrower = Borrower(id: id, name: name)
    borrowers.append(newBorrower)
    print("\(newBorrower) was added")

}

///
/// - Parameter borrowers:
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

    if let indexToedit: Int = (borrowers.firstIndex(where: { $0.id == idToEdit })) {
        let newName: String = input(forNotNullString: "Enter the borrower's updated name: ")
        borrowers[indexToedit].name = newName

    } else {
        print("There is no borrower with that ID.")
    }

}

func searchBooks(books: [Book]) {
    print(
        """
        Search for books:
        ---------------------
        """)
    let keyword: String = input(forNotNullString: "Enter a title, author or keyword to search: ")
        .lowercased()

    let results: [Book] = books.filter {
        ($0.title.lowercased().contains(keyword) || $0.author.lowercased().contains(keyword))
            && $0.exists
    }

    if results.isEmpty {
        print("No books contain that keyword.")
    } else {
        print("\(results.count) results found:\n")
        for book in results {
            print(book)
        }
    }
}

func searchBorrowers() {
    print("searchBorrowers() ran")
}

///
/// - Parameters:
///   - loans:
///   - books:
///   - borrowers:
func viewLoans(loans: [Loan], books: [Book], borrowers: [Borrower]) {
    print(
        """
        Loan history:
        ---------------
        """)

    for loan in loans {
        print(loan.loanDetails(books: books, borrowers: borrowers))
    }
}

//
let maxLoanPeriod = 21

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
    menuOption(optionNumber: 11, description: "View loan records."),
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
                    case 4: borrowBook(from: books, from: borrowers, to: &loans)
                    case 5: returnBook(to: &loans, books: books, borrowers: borrowers)
                    case 6: viewBorrowers(borrowers: borrowers, loans: loans)
                    case 7: addBorrower(to: &borrowers)
                    case 8: editBorrower(from: &borrowers)
                    case 9: searchBooks(books: books)
                    case 10: searchBorrowers()
                    case 11: viewLoans(loans: loans, books: books, borrowers: borrowers)
                    default: print("Invalid. Please enter a number from the menu, or 'done'.")
                    }
                } else {
                    print("Invalid. Please enter a number from the menu, or 'done'.")
                }
            }
        }
    }
}
