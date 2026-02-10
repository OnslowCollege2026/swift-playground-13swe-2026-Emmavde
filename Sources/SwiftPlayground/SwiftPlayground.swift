// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

@main
struct SwiftPlayground {
    static func main() {

        // Task: Analysing student scores
        // You are given an array of student scores out of 100. Use map, filter, and reduce to find the average score of students who passed.

        // Complete these steps:

        // Use map to curve the scores by adding 5 extra points to each student’s score.
        // Use filter to keep only the passing scores (50 or more).
        // Use reduce to calculate the average score of the passing students.
        // Use the following input:

        let scores = [45, 78, 89, 32, 50, 92, 67, 41, 99, 56]

        let curvedScores = scores.map {$0 + 5}
        print(curvedScores)
        let passingScores = curvedScores.filter {$0 > 50}
        print(passingScores)
        let averageScore = passingScores.reduce(0) {($0 + $1)/passingScores.count}

        print(averageScore)
        print("---------------")


        let numbers = [1, 2, 3, 4, 5]

        // Uses map to cube all the numbers in the array.
        let cubedNumbers = numbers.map { number in
            return number * number * number
        }
        print(cubedNumbers)  // Output: [1, 8, 27, 64, 125]




        // Filter for only the even cubed numbers
        let evenNumbers = cubedNumbers.filter { number in
            return number % 2 == 0
        }
        print(evenNumbers)  // Output: [8, 64]





        // Sum the even numbers
        let total = evenNumbers.reduce(0) { result, number in
            return result + number
        }
        print(total)




        // Use reduce to find the product of all numbers in an array. Print the result.
        let numbers2 = [7, 14, 21, 28, 35]

        let product = numbers2.reduce(1) { result, number in
            return result * number
        }

        print(product)




        // Use filter to keep only words longer than four characters. Print the new array of words.
        let words = ["apple", "cat", "banana", "dog", "grape", "kiwi"]

        let longWords = words.filter { word in
            return word.count > 4
        }

        print(longWords)





        // Use reduce to find the longest word in an array. The initial value can be an empty string ("").
        // You can find the length of a word with the .count property, which works like Python’s len().

        let words2 = ["apple", "banana", "grape", "strawberry", "kiwi"]

        let longestWord = words2.reduce("") { result, word in
            return word.count > result.count ? result : word
        }

        print(longestWord)
    }
}
