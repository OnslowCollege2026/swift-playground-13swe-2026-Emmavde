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
    }
}

