// The Swift Programming Language
// https://docs.swift.org/swift-book

@main
struct SwiftPlayground {
    static func main() {

        // These are the lunch costs for Monday to Friday.
        let lunches: [Double] = [6.50, 8.00, 5.75, 9.20, 7.10]
        // Use a for loop to print the lunch cost for each day.
        for (index, cost) in lunches.enumerated() {
            print("Day \(index + 1): $\(cost)")
        }
    }
}


let budget: Double = 35.00

///Total Cost Function
///
/// This should return the total cost of all lunches.
func totalCost(prices: [Double]) -> Double {
    var sum: Double = 0.0
    for cost in prices {
        sum += cost
    }
    return sum
}

/// Budget Check Function
/// 
/// This should return true if the student spent more than the budget.
func isOverBudget(total: Double, budget: Double) -> Bool {
    return total > budget
}

/// Average Cost Function
/// 
/// This should return the average lunch cost per day.
func averageCost(prices: [Double]) -> Double {

    var sum: Double = 0
    for price in prices {
        sum += price
    }
    return sum / Double(prices.count)
}

