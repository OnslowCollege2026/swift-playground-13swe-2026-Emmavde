// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

// Tasks - SchoolSystem Part 1

// Create a Student that conforms to Identifiable
// Properties: id, name, age
struct Student: Identifiable {
    let id: Int
    var name: String
    var age: Int
}

// Create a Course that conforms to CustomStringConvertible
// Properties: id, title, courseDescription
// Description should print a readable summary line
struct Course: CustomStringConvertible {
    let id: Int
    var title: String
    var courseDescription: String
    var description: String {
        """
        Course title: \(title) ID: \(id)
        Description: \(courseDescription)
        """
    }
}

// Create an Enrolment that conforms to Codable
// Properties: studentId, courseId
// Encode one submission with JSONEncoder and decode it with JSONDecoder to make sure it works
struct Enrolment: Codable, Hashable {
    let studentId: Int
    let courseID: Int

    // Update Enrolment to conform to Hashable
    // Implement an enrolment hash to be the studentId and courseId connected by a full stop. 

    // Build a Set of Enrolments with duplicates and print the unique count

        func hash(into hasher: inout Hasher) {
        hasher.combine(studentId)
        hasher.combine(courseID)
    }
}

// Tasks - SchoolSystem Part 2

// Create ScoreEntry that conforms to Comparable
// Properties: studentId, points
// Implement < using points
struct ScoreEntry: Comparable, Equatable {
    let studentId: Int
    var points: Int

    static func < (lhs: ScoreEntry, rhs: ScoreEntry) -> Bool {
        lhs.points < rhs.points
    }
    // Update ScoreEntry to conform to Equatable.
    // Implement == so that ScoreEntrys are equal when the points are equal regardless of the studentId
        static func == (lhs: ScoreEntry, rhs: ScoreEntry) -> Bool {
            lhs.points == rhs.points
    }
}

// Tasks - SchoolSystem Extension!
// Update your program so that every struct conforms to more than one protocol. Keep the original protocol and add the following:

// Student: CustomStringConvertible, Codable
// Course: Identifiable, Equatable, Codable
// Enrolment: Identifiable, Equatable, CustomStringConvertible
// ScoreEntry: Comparable, Equatable, Codable
// Test each struct with at least two behaviours you’ve added. If you’re feeling adventurous, attempt to encode and decode each of your objects.
@main
struct SwiftPlayground {
    static func main() {

        // Tasks - SchoolSystem Part 1

        // Encode one submission with JSONEncoder and decode it with JSONDecoder to make sure it works
        do {
            let enrolment1 = Enrolment(studentId: 1234, courseID: 5678)
            let data = try JSONEncoder().encode(enrolment1)
            let decoded = try JSONDecoder().decode(Enrolment.self, from: data)
            print(data)
            print(decoded)
        } catch {
            print("Error:")
        }

        // Tasks - SchoolSystem Part 2

        // Create an array and print entries sorted from lowest to highest
        let scores: [ScoreEntry] = [
            ScoreEntry(studentId: 5678, points: 9),
            ScoreEntry(studentId: 1234, points: 5),
            ScoreEntry(studentId: 9123, points: 20)
        ]

        print(scores.sorted())

        // Tasks - SchoolSystem Part 3

        // In the main test flow, print:

        // Create two Students
        // Name: Jules, Age: 16
        // Name: Stan, Age: 17
        let jules: Student = Student(id: 1234, name: "Jules", age: 16)
        let stan: Student = Student(id: 5678, name: "Stan", age: 17)
        let ash: Student = Student(id: 9123, name: "Ash", age: 18)

        // Create a Course
        // Title: 13SWE, Course Description: “Sweet Food in Hospitality”
        let course1: Course = Course(id: 678, title: "13SWE", courseDescription: "Sweet Food in Hospitality")

        // Create an Enrolment: Enrol Stan and Jules in 13SWE
        // Encode and decode the enrolment. Print the HASH of the decoded enrolment
        // Create another Enrolment: Enrol Stan again in 13SWE using a new Enrolment object

        let enrolmentsArray: [Enrolment] = [
            Enrolment(studentId: jules.id, courseID: 678),
            Enrolment(studentId: stan.id, courseID: 678),
            Enrolment(studentId: stan.id, courseID: 678)
        ]
        // Add all enrolment objects to a Set and print out the Set Count
        let enrolmentsSet: Set<Enrolment> = Set(enrolmentsArray)
        print(enrolmentsSet.count)


        // Create two ScoreEntry
        // StudentId: Jules ID, Points: 55
        // StudentId: Stans ID, Points: 50
        // Add both ScoreEntry to an array and sort it. Print the results.
        // Create a new Student called Ash, Age 18, and create a ScoreEntry for Ash with 55 points
        // Compare Ash’s ScoreEntry with Jules’ ScoreEntry. Confirm equality using == and
        // print the result

        let scores2: [ScoreEntry] = [
            ScoreEntry(studentId: jules.id, points: 55),
            ScoreEntry(studentId: stan.id, points: 50), 
            ScoreEntry(studentId: ash.id, points: 55)
        ]

        print(scores2.sorted())
        print(scores2.first{$0.studentId == jules.id} == scores2.first{$0.studentId == ash.id})


    }
}
