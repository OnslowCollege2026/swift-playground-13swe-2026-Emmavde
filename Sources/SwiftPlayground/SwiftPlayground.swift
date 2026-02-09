// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

@main
struct SwiftPlayground {
    static func main() {

        // Use filter to keep only words longer than four characters. Print the new array of words.
        let words = ["apple", "cat", "banana", "dog", "grape", "kiwi"]

        let longWords = words.filter { word in
            return word.count > 4
        }

        print(longWords)

        // Use reduce to find the product of all numbers in an array. Print the result.
        let numbers = [7, 14, 21, 28, 35]

        let product = numbers.reduce(numbers[0]) { result, number in
        return result * number
        }

        print(product)

    }
}
