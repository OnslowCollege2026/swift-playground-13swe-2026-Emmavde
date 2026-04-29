// Assessment Task:
// school library book borrowing system
// Created 22/04/2026
// Emma van den Eijkhoff

import Foundation
import GRDB

/// A Borrower who takes out loans.
struct Borrower: Identifiable, CustomStringConvertible, Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "Borrower"

    /// The Borrower ID.
    let id: Int

    /// The Borrower's name.
    var name: String

    /// The borrower's ID and name formated in a string.
    var description: String {
        "ID: \(id) | Name: \(name) "
    }

    /// Calculates the number of books a borrower currently has on loan.
    ///
    /// - Parameter loans: The list of loan records the borrower ID is checked against.
    /// - Returns: The number of current loans the borrower has (books that are not returned).
    func currentLoans(loans: [Loan]) -> Int {
        loans.reduce(0) { $0 + (($1.borrowerId == id && !$1.returned) ? 1 : 0) }
    }

        enum CodingKeys: String, CodingKey {
        case id = "Borrower ID"
        case name = "Name"
    }

}

/// A book in the library.
struct Book: Identifiable, CustomStringConvertible, Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "Book"

    /// The Book ID.
    let id: Int

    /// The Books's title.
    let title: String

    /// The Book's author.
    let author: String

    /// Whether or not the book stilll exists in the libraries catalouge.
    var exists: Bool

    /// Formats the book's ID, title and author in a string.
    var description: String {
        "ID: \(id) | Title: \(title) | Author: \(author)"
    }

    /// Checks whether the book is available to borrow or not.
    ///
    /// - Parameter loans: The list of loan records the book is checked against.
    /// - Returns: A boolean value of whether the book is available or not.
    func isAvailable(loans: [Loan]) -> Bool {

        // Check that the book's id is not in a loan that has not bean returned.
        !loans.contains(where: { $0.bookId == id && !$0.returned })
    }

        enum CodingKeys: String, CodingKey {
        case id = "Book ID"
        case title = "Title"
        case author = "Author"
        case exists = "Exists"
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

    /// Gets the book and borrower details of a loan.
    ///
    /// - Parameters:
    ///   - books: The array of books.
    ///   - borrowers: The array of borrowers.
    /// - Returns: A string containing the loans details as well as the title of the book, and the borrowers name.
    func loanDetails(books: [Book], borrowers: [Borrower]) -> String {
        let title: String = books.first(where: { $0.id == bookId })?.title ?? ""
        let borrowerName: String = borrowers.first(where: { $0.id == borrowerId })?.name ?? ""
        return
            ("Loan ID: \(id) | '\(title)' loaned to \(borrowerName) for \(loanPeriod) days. \(returned ? "" : "Not") Returned. ")
    }

        enum CodingKeys: String, CodingKey {
        case id = "Loan ID"
        case borrowerId = "Borrower ID"
        case bookId = "Book ID"
        case loanPeriod = "Loan Period"
        case returned = "Returned"
    }

}

/// A single option on the action menu option.
struct menuOption {
    // The option's number it is selected by.
    let optionNumber: Int

    // The description of what action it performs.
    let description: String
}

/// Gets user input in the form of a string.
///
/// - Parameter prompt: The prompt displayed to the user.
/// - Returns: The string the user inputted.
func input(forString prompt: String) -> String? {
    // Print the prompt/question.
    print(prompt, terminator: " ")

    // Allow the user to enter an input.
    let userInput: String? = readLine()

    // Return the user's input.
    return userInput
}

/// Gets user input in the form of a string, repeating until not null input is given.
///
/// - Parameter prompt: The prompt displayed to the user.
/// - Returns: The string the user inputted.
func input(forNotNullString prompt: String) -> String {

    // Repeat until a input that is not null is given.
    while true {
        // Print the prompt/question.
        print(prompt, terminator: " ")

        // Allow the user to enter an input.
        // If it is not null, return the input and stop looping.
        if let userInput: String = readLine(), userInput.count > 0 {
            return userInput
        }
        // If the input was null, print an error message and keep looping.
        print("Invalid. Input cannot be empty.")
    }
}
/// Get user input in the form of an integer.
///
/// - Parameter prompt: The prompt displayed to the user.
/// - Returns: The user's input as an integer value.
func input(forInt prompt: String) -> Int? {
    // Allow the user to enter an input.
    if let userInput = input(forString: prompt), let intInput = Int(userInput) {
        // if the input was an Integer, return that value.
        return intInput
    } else {
        // if it was not an integer, return nil.
        return nil
    }

}

/// Gets user input in the form of an integer, repeating until an integer is given.
///
/// - Parameter prompt: The prompt displayed to the user.
/// - Returns: The user's input as an integer value.
func input(loopUntilPositiveIntGiven prompt: String) -> Int {
    // Loop until an integer is given.
    while true {
        // Allow the user to enter an input.
        if let userInput = input(forInt: prompt), userInput > 0 {
            // Rteurn that input and stop looping if an Int is given.
            return userInput
        }
        // Otherwise print an error message and keep looping.
        print("Invalid. Please enter a positive integer.")
    }
}

/// Print the menu of user actions.
func showActions() {
    // Print a heading.
    print(
        """
        \n------------------------------------
        Choose an action from the menu:
        ------------------------------------
        """)

    // Print each option along with its option number in a list.
    for option in actionOptions {
        print("\(option.optionNumber). \(option.description)")
    }
}
/// View all of the books in the library.
///
/// - Parameters:
///   - books: The array of all books in the library.
///   - loans: The array of all loan history.
func viewBooks(books: [Book], loans: [Loan]) {
    // Print the user's view options.
    print(
        """
        A. View all books.
        B. View available books.
        """)

    // An empty array for the filtered books.
    var filteredBooks: [Book] = []

    // A varaiable that controls the input loop.
    var looping: Bool = true
    // Loop until a valid input is given.
    while looping {

        // Ask the user's option choice.
        let optionInput: String = input(forNotNullString: "Please enter the option letter: ")

        // If the user enter 'a'
        if optionInput.lowercased() == "a" {
            // Filter for only the existing books.
            filteredBooks = books.filter({ $0.exists })
            // Stop looping.
            looping = false
            // If the user enter 'b'
        } else if optionInput.lowercased() == "b" {
            // Filter for books that exist and are currently available.
            filteredBooks = books.filter({ $0.exists && $0.isAvailable(loans: loans) })
            // Stop looping
            looping = false
            // If input is invalid, print an error message and continue looping.
        } else {
            print("Invalid. Enter 'a' or 'b'.")
        }
    }

    // Print the heading:
    print(
        """
        \nBook list:
        ----------------
        """)

    // Print each of the filtered for books in a list, sorted by ID number.
    for book in filteredBooks.sorted(by: { $0.id < $1.id }) {
        var availability: String = "Not available"
        // Determine the books avaialbility.
        if book.isAvailable(loans: loans) {
            // set default availability as availble.
            availability = "Available"
        }
        // Print the book's details and its availability.
        print("\(book) | \(availability)")
    }

}

/// View all of the borrowers in the system.
///
/// - Parameters:
///   - borrowers: The array of all borrowers in the library.
///   - loans: The array of all the loans in the library.
func viewBorrowers(borrowers: [Borrower], loans: [Loan]) {

    // Print a heading.
    print(
        """
        Borrowers list:
        ---------------------
        """)

    // Print each borrower in the list, sorted by ID number.
    for borrower in borrowers.sorted(by: { $0.id < $1.id }) {

        // Calculate the number of loans the borrower currently has out.
        let currentLoans: Int = borrower.currentLoans(loans: loans)

        // Print the borrower's details and their number of current loans.
        print("\(borrower) | \(currentLoans) books on loan.")
    }
}

/// Add a book to the library.
///
/// - Parameter books: The array of all the books in the library.
func addBooks(to books: inout [Book]) {

    // Print a heading.
    print(
        """
        Add a book:
        ------------------
        """)

    // Make the ID of the new book 1 more than the current highest ID number.
    let id = (books.map { $0.id }.max() ?? 0) + 1

    // Gte input for the new book's title.
    let title: String = input(forNotNullString: "Enter book title: ")

    // Get input for the new book's author name.
    let author: String = input(forNotNullString: "Enter Author's name: ")

    // Create the new book.
    let newBook: Book = Book(id: id, title: title, author: author, exists: true)

    // Add the new book to the library.
    books.append(newBook)

    // Print the new book's details and comfirmation that it was added.
    print("\(newBook) was added")

}

/// Remove a boomk from the library.
///
/// - Parameter books:The array of all the books in the library.
func removeBook(from books: inout [Book]) {

    // Print a heading.
    print(
        """
        Remove a book: (This will not remove the book from loan history.)
        -------------------------------------------------------------------
        """)

    // Loop until a valid input is given.
    while true {

        // Get input for the ID number of the book, if it is valid, stop looping.
        guard let idToRemove = input(forInt: "Enter the ID number of the book to delete: "),
            idToRemove > 0
        else {
            // If the ID is not a positive integer, display an error message and continue looping.
            print("Please enter a valid ID number.\n")
            continue
        }

        // Check if there is an existing book of the given ID.
        if let IndexToRemove: Int = (books.firstIndex(where: { $0.id == idToRemove && $0.exists }))
        {
            // If there is, remove the book.
            books[IndexToRemove].exists = false
            print("\(books[IndexToRemove]) has been removed from the library.")

            // If not, print an error message.
        } else {
            print("Book does not exist or has already been removed.")
        }
        return
    }
}

/// Borrow a book from the library (add a loan)
///
/// - Parameters:
///   - books: The array of all the books in the library.
///   - borrowers: The array of all the borrowers of the library.
///   - loans: The array of all loan records that the new loan is added to.
func borrowBook(from books: [Book], from borrowers: [Borrower], to loans: inout [Loan]) {
    // Print a heading.
    print(
        """
        \nBorrow a book:
        -------------------
        """)

    // If there are no available books in the library, tell the user.
    if books.filter({ $0.isAvailable(loans: loans) }).isEmpty {
        print("Unfortunately all books are on loan. ")
    } else {

        // Make the ID of the new loan 1 more than the current highest ID number.
        let loanId: Int = (loans.map { $0.id }.max() ?? 0) + 1
        // Initalisation of the borrower ID for the new loan.
        var borrowerId: Int = 0
        // Initalisation of the book ID for the new loan.
        var bookId: Int = 0
        // Initalisation of the loan period for the new loan.
        var loanPeriod: Int = 0

        // Loop until a valid Borrower ID is given.
        while true {
            // Ask the user for their borrower ID.
            let id: Int = input(loopUntilPositiveIntGiven: "Enter your Borrower ID: ")
            // If there exists a borrower of that ID, stop looping
            if borrowers.contains(where: { $0.id == id }) {
                // Assign the borrower ID of the new loan as the user's input.
                borrowerId = id
                break
                // If not borrower of this ID exists, keep looping.
            } else {
                print("No borrower of this ID exists.")
            }
        }

        // Loop until a valid Book ID is given.
        while true {
            // Ask the user for the ID of the book they want to borrow,
            // repeating until a positve number is given.
            let id: Int = input(
                loopUntilPositiveIntGiven: "Enter the ID of the book you wish to borrow: ")

            // Check if there exists a book of this ID, and it is avalailable.
            if let bookToBorrow = books.first(where: { $0.id == id }),
                bookToBorrow.exists,
                bookToBorrow.isAvailable(loans: loans)
            {
                // If there is, assign the borrower ID of the new loan as the user's input.
                bookId = id
                // Stop looping.
                break
                // Otherwise, print an error message, and keep looping.
            } else {
                print("No book of this ID exists, or the book is currently unavialable.")
            }
        }

        // Loop until a valid loan period is given.
        while true {
            // Ask the user for the loan period.
            loanPeriod = input(
                loopUntilPositiveIntGiven: """
                    How many days do you wish to loan the book? (maximum loan period is \(maxLoanPeriod) days): 
                    """)

            // If the loan period is valid, stop looping.
            if loanPeriod > 0 && loanPeriod <= maxLoanPeriod {
                break
                // Otherwise, print an error message and keep looping.
            } else {
                print("The maximum loan period is \(maxLoanPeriod) days.")
            }
        }

        // Create the new loan using the inputted information.
        let newLoan: Loan = Loan(
            id: loanId, borrowerId: borrowerId, bookId: bookId, loanPeriod: loanPeriod,
            returned: false)

        // Add the new loan to the loan records.
        loans.append(newLoan)
        // Print the new loan's details and a comfirmation message.
        print("\n\(newLoan.loanDetails(books: books, borrowers: borrowers))")
    }

}

/// Return a book to the library.
///
/// - Parameters:
///   - loans: The array of all loan records.
///   - books: The array of all books in the library.
func returnBook(to loans: inout [Loan], books: [Book], borrowers: [Borrower]) {

    // Print a heading.
    print(
        """
        Return a book:
        --------------------
        """)

    // Ask the user for the ID of the book being returned.
    let id = input(loopUntilPositiveIntGiven: "Enter the ID of the book you are returning: ")

    // Check if a book of that ID is on loan.
    if let indexToedit: Int = loans.firstIndex(where: { $0.bookId == id && !$0.returned }) {

        // Return the book.
        loans[indexToedit].returned = true

        // Print the details of the returned loan.
        print(loans[indexToedit].loanDetails(books: books, borrowers: borrowers))

        // If the book couldn't be returned, print an error message.
    } else {
        print("This book is not on loan, or does not exist.")
    }
}

/// Add a borrower to the library system.
///
/// - Parameter borrowers: The array of all borrowers of the library.
func addBorrower(to borrowers: inout [Borrower]) {

    // Print a heading.
    print(
        """
        Register a borrower:
        -----------------------
        """)

    // Make the ID of the new loan 1 more than the current highest ID number.
    let id = (borrowers.map { $0.id }.max() ?? 0) + 1

    // Get input for the new borrower's name, looping until a name is given.
    let name: String = input(forNotNullString: "Enter the borrower's name: ")

    // Create the instance of the new borrower.
    let newBorrower: Borrower = Borrower(id: id, name: name)

    // Add the new borrower to the library.
    borrowers.append(newBorrower)

    // Print the new borrower's details, and a comfirmation message.
    print("\(newBorrower) was added")

}

/// Edit a borrower's details.
///
/// - Parameter borrowers: The array of all borrrower's of the library.
func editBorrower(from borrowers: inout [Borrower]) {

    // Print a heading.
    print(
        """
        Edit borrower details:
        -------------------------
        """)

    // Get input for the ID of the borrower being edited,
    // looping until a positive integer is given.
    let idToEdit = input(loopUntilPositiveIntGiven: "Enter the borrower's ID number: ")

    // Check if a borrower of that ID exists.
    if let indexToedit: Int = (borrowers.firstIndex(where: { $0.id == idToEdit })) {

        // If they exist, get input for their updated name.
        let newName: String = input(forNotNullString: "Enter the borrower's updated name: ")

        // Change the borrower's name to the updated name.
        borrowers[indexToedit].name = newName

        // If no borrower of the given ID exists, print an error message.
    } else {
        print("There is no borrower with that ID.")
    }

}

/// Search for a book in the library.
///
/// - Parameter books: The array of all the books in the library.
func searchBooks(books: [Book]) {

    // Print a heading.
    print(
        """
        \nSearch for books:
        ---------------------
        """)

    // Get user input of a keyword to search for, looping until a keyword is given.
    let keyword: String = input(
        forNotNullString:
            "Enter a title, author or keyword to search: "
    )
    .lowercased()

    // Create an array of results for the search.
    let results: [Book] = books.filter {
        // Add existing books to the array if their title or author name contain the keyword.
        ($0.title.lowercased().contains(keyword) || $0.author.lowercased().contains(keyword))
            && $0.exists
    }

    // If there were no search results, tell the user.
    if results.isEmpty {
        print("No books contain that keyword.")
    } else {
        // Display the number of book results found.
        print("\(results.count) results found:\n")

        // Print the details of each book from the results.
        for book in results {
            print(book)
        }
    }
}

/// Search for a borrower.
///
/// - Parameter borrowers:
func searchBorrowers(borrowers: [Borrower]) {

    // Print a heading.
    print(
        """
        \nSearch for borrowers:
        ---------------------
        """)

    // Get user input of a keyword/name to search for, looping until a keyword is given.
    let keyword: String = input(forNotNullString: "Enter a part of the borrower's name: ")
        .lowercased()

    // Create an array of search results.
    let results: [Borrower] = borrowers.filter {
        // Add a borrower to the results if their name contains the keyword.
        ($0.name.lowercased().contains(keyword))
    }

    // If there were no results, tell the user.
    if results.isEmpty {
        print("No borrower's have that name.")
    } else {
        // Display the number of borrower results found.
        print("\(results.count) results found:\n")

        // Print the details of each borrower from the results.
        for borrower in results {
            print(borrower)
        }
    }
}

/// View all loan records of the library.
///
/// - Parameters:
///   - loans: The array of all loan records for the library.
///   - books: The array of all books in the library.
///   - borrowers: The array of all borrower's of the library.
func viewLoans(loans: [Loan], books: [Book], borrowers: [Borrower]) {

    // Print a heading.
    print(
        """
        Loan history:
        ---------------
        """)

    // Print each the details of each loan record, sorted by loan ID.
    for loan in loans.sorted(by: { $0.id < $1.id }) {
        print(loan.loanDetails(books: books, borrowers: borrowers))
    }
}

// The maximum amount in days the a loan can be taken out for.
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

            // Print the menu of actions.
            showActions()

            // Let the user enter the number of the option they want to select.
            let optionInput: String = input(
                forNotNullString: "\nEnter option number, or 'done' to finish: ")

            // If they the user is finished, end the program.
            if optionInput.lowercased() == "done" {
                running = false
            }

            else {
                // Convert the user's input into an integer, and call the function of the corresponding option number.
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
                    case 10: searchBorrowers(borrowers: borrowers)
                    case 11: viewLoans(loans: loans, books: books, borrowers: borrowers)

                    // If the number wasn't an option, print an error message.
                    default: print("Invalid. Please enter a number from the menu, or 'done'.")
                    }

                    // If the input was invalid, print an error message.
                } else {
                    print("Invalid. Please enter a number from the menu, or 'done'.")
                }
            }
        }
    }
}
