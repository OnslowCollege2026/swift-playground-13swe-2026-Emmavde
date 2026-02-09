// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

/// Formats a `Double` as currency with exactly two decimal places.
/// - Parameter value: The numeric value to format.
/// - Returns: A string like `$6.50`.
func money(_ value: Double) -> String {
    "$" + String(format: "%.2f", value)
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

/// Most Expensive Day function
/// 
/// It should find the most expensive lunch cost.
func mostExpensiveDay(prices: [Double]) -> Double {
    if let highestCost: Double = prices.max() {
        return highestCost
    } else {
        return 0.0
    }
}


@main
struct SwiftPlayground {
    static func main() {

        // These are the lunch costs for Monday to Friday.
        let lunches: [Double] = [6.50, 8.00, 5.75, 9.20, 7.10]

        print("""

        --------------------------
        LUNCH SPENDING TRACKER:
        --------------------------
        """)

        print("""

        Daily lunch costs:
        --------------------------
        """)
        // Use a for loop to print the lunch cost for each day.
        for (index, cost) in lunches.enumerated() {
            print("Day \(index + 1): \(money(cost))")

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


        print("""

        -------------------------
        """)
        var snackTotal: Double = 0.0
        // While loop that keeps adding snacks until snack spending reaches at least $10.
        while snackTotal < 10  {
            snackTotal += 2.5
            print("Snack total: \(money(snackTotal))")
        }

        // Print the final summary
        print("""
        
        --------------------------------
        FINAL SUMMARY:
        --------------------------------
        Lunch total: \(money(totalLunchCost))
        Snack total: \(money(snackTotal))
        Combined total: \(money(totalLunchCost + snackTotal))
        Average lunch cost: \(money(averageCost(prices: lunches)))
        Most expensive lunch cost: \(money(mostExpensiveDay(prices: lunches)))
        """)
    }
}