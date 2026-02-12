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

        // let lastWing = archive.last
        // print(lastWing)

        // if let word = archive.last.last.first {
        //                 print(word ?? "")
        //                         }
        // }



        // Task C: the midnight filter
        // You are given a list of sightings with a name and a danger score.

        // Use filter to keep only sightings where the name starts with "m" or "w".

        // Use map to extract the scores, then reduce to calculate the total.

        // Finally, use min(by:) and max(by:) to find the lowest and highest scores in the filtered set.

        let sightings = [
            (name: "moth", score: 3),
            (name: "wolf", score: 9),
            (name: "raven", score: 4),
            (name: "mist", score: 7),
            (name: "wisp", score: 2)
        ]


        let totalFilteredScores = sightings.filter {$0.name.hasPrefix("m") or $0.name.hasPrefix("w")}
    }
}

