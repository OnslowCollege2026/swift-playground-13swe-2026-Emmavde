// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation



// Task A: convert open functions to methods
struct Book {
    let title: String
    let author: String
    let pages: Int

    func summary() -> String {
        return """
        Title: \(title)
        Author: \(author)
        Pages: \(pages)
        """
    }
}

// Task B: static method challenge
struct Temperature {
    static func toFahrenheit(celsius: Double) -> Double {
        return celsius * 1.8
    }
    static func toCelsius(fahrenheit: Double) -> Double {
        return fahrenheit / 1.8
    }
}



// Task C: mutating method challenge

struct Timer {
    var seconds: Double
    var isRunning: Bool

    mutating func start() {
        isRunning = true
    }

    mutating func tick() {
        if isRunning {
            seconds += 1
        }
    }

    mutating func reset() {
        seconds = 0
        isRunning = false
    }


}


// Task D: mixed design decision
// Build a struct Cart with property itemsCount starting at 0.
// Add a type-level rule with static let freeShippingThreshold = 5.
// Add a mutating method addItem() that increments itemsCount by 1.
// Add an instance method shippingMessage() -> String that uses itemsCount and returns:
// "Free shipping" when itemsCount >= Cart.freeShippingThreshold
// "Shipping applies" otherwise
// Add a static helper qualifiesForFreeShipping(count: Int) -> Bool so the shipping rule can be reused in other places (for example previews, reports, or tests without a Cart instance).
// Create one Cart instance and call addItem() in a loop.
// After each add, print both cart.itemsCount and cart.shippingMessage().
// In comments, explain why addItem() and shippingMessage() are instance behaviour, while freeShippingThreshold and qualifiesForFreeShipping are type-level behaviour.


// Task E: method to computed property
// Create a struct called Badge with properties name and level.
// Add an instance method label() -> String that returns text like "Ranger - Level 4".
// Create at least one Badge instance and print the method result.
// Convert label() into a computed property label: String.
// Print the new computed property and confirm the output is the same.
// Extension for Super Players!
// Take one extra step to strengthen your design choices with computed properties. Add at least one computed property to each of Tasks A through D, or convert one existing method from any task into a computed property and explain why that change improves readability.
@main
struct SwiftPlayground {
    static func main() {

        // Task A: convert open functions to methods
        let books: [Book] = [
            Book(title: "The 3-body Problem", author: "Cixin Liu", pages: 5000),
            Book(title: "The Return of the King", author: "Tolkein", pages: 4000)
        ]

        books.forEach() { book in
        print(book.summary())
        print()
        }

        // Task B: static method challenge
        let numbers: [Double] = [22, 40, 54]

        for number in numbers {
            print("\(number) degrees celsius = \(Temperature.toFahrenheit(celsius: number)) degrees fahrenheit")
                print("\(number) degrees fahrenheit = \(Temperature.toCelsius(fahrenheit: number)) degrees celsius")
                print()
        }


        // Task C: mutating method challenge
        // Test your struct by calling the methods in sequence and printing values after each step.

        var tenSecTimer = Timer(seconds: 0, isRunning: false)
        
        tenSecTimer.start()

        while tenSecTimer.seconds <= 10 {
            print(tenSecTimer)
            tenSecTimer.tick()
        }

        tenSecTimer.reset()
    }
}