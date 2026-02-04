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

            // If any lunch costs more than $9.00, print:High spending day detected.
            if cost > 9.0 {
                print("High spending day detected.")
            }
        }

        // Set a weekly budget:
        let budget: Double = 35.00

        // Calculate the total lunch cost:
        let totalLunchCost: Double = totalCost(prices: lunches)

        // If the student is over budget, print:Warning: You overspent this week.
        if isOverBudget(total: totalLunchCost, budget: budget) {
            print("Warning: You overspent this week.")
        
        // If the student is under budget, print:You stayed within budget.
        } else {
            print("You stayed within budget.")
        }
    }
}




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

