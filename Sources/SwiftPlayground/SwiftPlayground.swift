// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation


@main
struct SwiftPlayground {
    static func main() {

        // Task A: hidden numbers

        // You are given an array containing animal names and number strings.
        let mixed = ["cat", "7", "owl", "15", "dog", "3"]

        // Use compactMap to keep only the numbers and convert them to Int, then print the result.
        let numbers = mixed.compactMap {Int($0)}
        print(numbers)

        // Then, as an alternative check, use allSatisfy on the original array to test if every item is a number string.
        let allNumbers = mixed.allSatisfy {Int($0) != nil}
        print(allNumbers)



        // Task B: the haunted archive
        // The archive has wings, each wing has rooms, each room has shelves, and each shelf holds words.

        // Find the first item of the last item of the last item of the last item of the archive.

        // Use first and last to solve the riddle, and print the final word.

        let archive = [
            [
                [["candle", "dust"], ["mirror", "ash"]],
                [["whisper", "shadow"], ["clock", "veil"]]
            ],
            [
                [["stone", "key"], ["relic", "name"]],
                [["cipher", "bone"], ["ember", "seal"]]
            ]
        ]

        print(archive.last?.last?.last?.first ?? "")
        

        // Task C: the midnight filter
        // You are given a list of sightings with a name and a danger score.

        let sightings = [
            (name: "moth", score: 3),
            (name: "wolf", score: 9),
            (name: "raven", score: 4),
            (name: "mist", score: 7),
            (name: "wisp", score: 2)
        ]

        // Use filter to keep only sightings where the name starts with "m" or "w".
        // Use map to extract the scores, then reduce to calculate the total.

        let FilteredScores = sightings.filter {$0.name.hasPrefix("m") || $0.name.hasPrefix("w")}.map{$0.score}
        let totalFilteredScores = FilteredScores.reduce(0){$0 + $1}

        print("\nTotal danger score: \(totalFilteredScores)")

        // Finally, use min(by:) and max(by:) to find the lowest and highest scores in the filtered set.
        let lowestScore = FilteredScores.min{$0 < $1}
        let highestScore = FilteredScores.max{$0 < $1}

        print("lowest score: \(lowestScore ?? 0)")
        print("Highest score: \(highestScore ?? 0)")


        /// Create a function called accepts that takes a String and a closure parameter called isValid.
        /// The closure should have the type (String) -> Bool and decide if the input passes.
        /// Return true or false based on the closure.
        func accepts(_ input: String, isValid: (String) -> Bool) -> Bool {
            return isValid(input)
        }

        // Test your function with a predicate that only allows lowercase words and a predicate that only allows strings longer than 8 characters.
        let sample = "moonlight"

        print(accepts(sample) { $0 == $0.lowercased() })
        print(accepts(sample) { $0.count > 8 })
    }
}

