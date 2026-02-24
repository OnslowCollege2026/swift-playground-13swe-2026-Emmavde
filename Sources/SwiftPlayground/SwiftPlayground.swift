// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation



// Task A: convert open functions to methods
struct Book {
    let title: String
    let author: String
    let pages: Int

    var summary: String {
        """
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

    var summary: String {
        "\(seconds) seconds"
    }

}

// Task D: mixed design decision

struct Cart {
    var itemsCount: Int = 0
    let freeShippingThreshold: Int = 5

    mutating func addItem() {
        itemsCount += 1
    }

    var shippingMessage: String {
        if itemsCount >= freeShippingThreshold {
            "Free shipping"
        } else {"Shipping applies" }
    }

    func qualifiesForFreeShipping(count: Int) -> Bool {
        count >= freeShippingThreshold 
    }
}


// Task E: method to computed property
struct Badge {
    let name: String
    let level: Int

    var label: String {
        return "\(name) - level \(level)"
    }

}


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
        print(book.summary)
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
            print(tenSecTimer.summary)
            tenSecTimer.tick()
        }

        tenSecTimer.reset()

        // Task D: mixed design decision
        // Create one Cart instance and call addItem() in a loop.
        // After each add, print both cart.itemsCount and cart.shippingMessage().
        // In comments, explain why addItem() and shippingMessage() are instance behaviour, while freeShippingThreshold and qualifiesForFreeShipping are type-level behaviour.

        var cart: Cart = Cart()

        while cart.itemsCount <= 10 {
            cart.addItem()
            print("\nItems in the cart: \(cart.itemsCount)")
            print("Shipping status: \(cart.shippingMessage)")
        }

        // Task E: method to computed property
        // Create at least one Badge instance and print the method result.
        // Convert label() into a computed property label: String.
        // Print the new computed property and confirm the output is the same.

        let badge: Badge = Badge(name: "Warrior", level: 10)
        print()
        print(badge.label)

    }
}