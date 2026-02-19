// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

struct Student {
    let id: Int
    var name: String
    var age: Int
    let nsn: Int
    var email: String

    func summary() -> String {
        return"""
        ID:    \(id)
        Name:  \(name)
        Age:   \(age)
        NSN:   \(nsn)
        email: \(email)
    """
    }
}

@main
struct SwiftPlayground {
    static func main() {

        // Students task:
        let emma = Student(
            id: 12356,
            name: "Emma",
            age: 17,
            nsn: 12345678,
            email:" emma.vandeneijkhoff@student.onslow.school.nz"
        )

        print(emma.summary())

        let students: [Student] = [
            Student(id: 123, name: "Sophie", age: 17, nsn: 1234567, email: "sophie@student.onslow.school.nz"),
            Student(id: 223, name: "Willow", age: 3, nsn: 2234567, email: "willow@onslow"),
            Student(id: 323, name: "Peter", age: 14, nsn: 3234567, email: "peter@onslow"),
            Student(id: 423, name: "Kate", age: 16, nsn: 4234567, email: "kate@onslow"),
            Student(id: 523, name: "Steve", age: 109, nsn: 5234567, email: "steve@onslow")
        ]

        let inTenYears = students.map{"\($0.name) will be \($0.age + 10) in 10 years"}
        print(inTenYears)

        /// Formats a `Double` as currency with exactly two decimal places.
        func money(_ value: Double) -> String {
            "$" + String(format: "%.2f", value)
        }


        // Task A: race garage
        // Create a struct called Car with properties brand, model, and year.
        // Create two Car instances and print a sentence about each car.
        // Use dot syntax to print each property value.

        struct Car {
            let brand: String
            let model: String
            let year: Int

            func summary() -> String {
                return"""
            Brand: \(brand)
            Model: \(model)
            Year: \(year)
            """
            }
        }
        let cars: [Car] = [
            Car(brand: "Toyota", model: "Corolla", year: 2013),
            Car(brand: "Mazda", model: "Axela", year: 2016)
        ]

        for car in cars {
            print()
            print(car.summary())
        }


        // Task B: mini banking model
        // Create a struct called BankAccount with properties owner and balance.
        // Add a method named description() that returns a sentence with both values.
        // Create two accounts and print description() for each one.

        struct BankAccount {
            var owner: String
            var balance: Double

            func description() -> String {
                return """
                \(owner)'s bank account balance is $\(balance)).
                """
            }
        }

        let accounts: [BankAccount] = [
            BankAccount(owner: "Emma", balance: 10000000000),
            BankAccount(owner: "Steve", balance: 3)
        ]
        for account in accounts {
            print()
            print(account.description())
        }

        // Task C: area checker
        // Create a struct called Rectangle with properties width and height.
        // Add a method named area() that returns the area.
        // Create two rectangles, print both areas, and compare which is larger.

        struct Rectangle {
            var width: Double
            var height: Double

            func area() -> Double {
                return width * height
            }
        }

        let rectangles: [Rectangle] = [
            Rectangle(width: 5.6, height: 7),
            Rectangle(width: 3, height: 19.5)
        ]

        for (index, rectangle) in rectangles.enumerated() {
            print()
            print("rectangle \(index + 1) area: \(rectangle.area())m²")
        }

        let largestArea = rectangles.max{$0.area() < $1.area()}?.area()
        print("Largest area: \(largestArea ?? 0.0)m²")


        // Task D: quest board
        // Create a struct called Quest with properties title, difficulty, and reward.

        // Add a method printBadge() that prints a formatted line such as "Hard Quest - 50 XP".

        // Create three quest instances, call printBadge() for each, and determine which quest has the highest difficulty.

        struct Quest {
            var title: String
            var difficulty: Difficulty
            var reward: Int

            func printBadge() -> String {
                return "\(difficulty)"
            }
        }

        enum Difficulty: Int {
            case easy = 1
            case medium = 2
            case hard = 3
        }

    }
}

