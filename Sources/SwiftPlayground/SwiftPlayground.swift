// 1. The paragraph/slide below contains some code that contains some errors, which your testing will help detect.
// 2. The program asks for guests at a wedding, how much they contributed as a gift, and then ranks them on a tier list. The more money they give,  the   higher the tier.
// 3. Lowest tier is F, then D, then C, then B, then A, then top tier is S.
// 4. Use the testing table in Google Classroom to record your testing of the program. Note any errors and what you think went wrong, then fix the errors. Keep adding new lines showing testing of that part of the program until it is fixed.
// 5. For **Kaiaka/M** and **Kairangi/E**, you need to ensure boundaries are handled correctly (both top and bottom, where applicable, inside and out) and invalid values (such as `nil`) don't cause the program to crash.

import Foundation

// MARK: - 1. Rank Struct
struct Rank: Comparable, CustomStringConvertible {
    let label: String
    let level: Int

    var description: String {
        return label
    }

    static func < (lhs: Rank, rhs: Rank) -> Bool {
        return lhs.level > rhs.level
    }

    static func == (lhs: Rank, rhs: Rank) -> Bool {
        return lhs.level == rhs.level
    }

    static func from(amount: Double) -> Rank {
        if amount >= 250 { return Rank(label: "F Tier", level: 0) }  // Should be S
        if amount >= 100 { return Rank(label: "D Tier", level: 1) }  // Should be A
        if amount >= 50 { return Rank(label: "C Tier", level: 2) }
        if amount >= 25 { return Rank(label: "B Tier", level: 3) }
        if amount >= 10 { return Rank(label: "A Tier", level: 4) }
        return Rank(label: "S Tier", level: 5)  // Should be F
    }
}

// MARK: - 2. Contribution Struct
struct Contribution: Equatable {
    let amount: Double
    let rank: Rank

    init(amount: Double) {
        self.amount = amount
        self.rank = Rank.from(amount: amount)
    }

    static func == (lhs: Contribution, rhs: Contribution) -> Bool {
        return lhs.amount == rhs.amount
    }
}

// MARK: - 3. Guest Struct
struct Guest: CustomStringConvertible, Equatable, Comparable {
    let name: String
    let contribution: Contribution

    var description: String {
        return "[\(contribution.rank)] \(name) | $\(contribution.amount)"
    }

    static func == (lhs: Guest, rhs: Guest) -> Bool {
        return lhs.name == rhs.name && lhs.contribution == rhs.contribution
    }

    static func < (lhs: Guest, rhs: Guest) -> Bool {
        if lhs.contribution.rank != rhs.contribution.rank {
            return lhs.contribution.rank < rhs.contribution.rank
        }
        return lhs.name > rhs.name
    }
}

// MARK: - 4. Party Logic
struct PartyOrganizer {
    var guestList: [Guest] = []

    mutating func addPreMadeGuests() {
        // Pre-made guests to help you test.
        guestList.append(Guest(name: "Rich Richard", contribution: Contribution(amount: 500.0)))
        guestList.append(Guest(name: "Broke Bob", contribution: Contribution(amount: 2.0)))
    }

    func printTierList() {
        print("\n--- BROKEN PARTY TIER LIST ---")
        let sortedList = guestList.sorted(by: <)

        for guest in sortedList {
            print(guest)
        }
    }
}

// Input functions:
func input(forString prompt: String) -> String? {
    print(prompt, terminator: " ")
    let userInput: String? = readLine()
    return userInput
}

func input(forDouble prompt: String) -> Double? {
    if let userInput = input(forString: prompt), let userNumber = Double(userInput) {
        return userNumber
    } else {
        return nil
    }
}

func input(forInt prompt: String) -> Int? {
    if let userInput = input(forString: prompt), let intInput = Int(userInput) {
        return intInput
    } else {
        return nil
    }
}

@main
struct SwiftPlayground {
    static func main() {
        var app = PartyOrganizer()
        app.addPreMadeGuests()
        var isRunning = true

        while isRunning {
            var name: String = ""
            var nameLooping = true

            while nameLooping {
                if let nameInput = input(forString: "\nEnter Name (or 'done'): "), nameInput != "" {
                    nameLooping = false
                    name = nameInput

                }
                if name.lowercased() == "done" {
                    isRunning = false
                    break

                }

            }

            var amountLooping = true
            var amount: Double = 0.0

            while amountLooping {
                if let amountInput = input(forDouble: "Enter Amount: "), amountInput >= 0 {
                    amountLooping = false
                    amount = amountInput
                } else {print("Please enter a positive number value.")}
            }

            let newGuest = Guest(name: name, contribution: Contribution(amount: amount))
            app.guestList.append(newGuest)
            print("Added \(name).")
        }

        app.printTierList()
    }
}
