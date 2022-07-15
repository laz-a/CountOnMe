//
//  Calculator.swift
//  CountOnMe
//
//  Created by laz on 03/07/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

final class Calculator {
    // Autorized operators
    private var operators = ["+", "-", "x", "÷"]

    // Expression in String format
    var expression: String = ""

    // Array of elements of String expression
    var elements: [String] {
        return expression.split(separator: " ").map { "\($0)" }
    }

    // Test if expression if correct
    var expressionIsCorrect: Bool {
        // Expression must have odd number of elements
        if elements.count % 2 == 1 {
            // For each elements
            for (index, value) in elements.enumerated() {
                // Even indexes must contain number, odd indexes must contain operator
                if (index % 2 == 0 && Double(value) == nil) || (index % 2 == 1 && !operators.contains(value)) {
                    return false
                }
            }
            return true
        }
        return false
    }

    // Test if division by 0 is present
    var divisionByZero: Bool {
        // Look for ÷ operator in expression
        for (index, value) in elements.enumerated() where value == "÷" {
            // If next elements of ÷ is 0 return true
            if elements.indices.contains(index + 1) {
                if let nextElement = Double(elements[index + 1]), nextElement == 0 {
                    return true
                }
            }
        }
        return false
    }

    // Test if last element is an operator
    var lastElementIsAnOperator: Bool {
        // Return true, if last elements of expression is an operator
        if let lastElement = elements.last, Double(lastElement) == nil {
            return true
        }
        return false
    }

    // Return the result of operation
    var result: String? {
        if let res = getResult() {
            // Save result in an other variable
            lastResult = res.toString
            return lastResult
        }
        return nil
    }

    // Result of the last operation
    var lastResult: String?

    // Make the operation
    private func getResult() -> Double? {

        // Copy of elements of expression
        var operations = elements

        // While we have more than 1 element in operations array
        while operations.count > 1 {
            if let idx = operations.firstIndex(of: ["x", "÷"]) ?? operations.firstIndex(of: ["+", "-"]) {
                // Get the numbers before and after the operator
                if let firstNumber = Double(operations[idx - 1]), let secondNumber = Double(operations[idx + 1]) {
                    var result: Double
                    // Make the operation according to operator
                    switch operations[idx] {
                    case "x":
                        result = firstNumber * secondNumber
                    case "÷":
                        result = firstNumber / secondNumber
                    case "+":
                        result = firstNumber + secondNumber
                    case "-":
                        result = firstNumber - secondNumber
                    default:
                        result = 0
                    }
                    // Remove elements of performed operation
                    operations.replaceSubrange((idx - 1)...(idx + 1), with: ["\(result)"])
                }
            }
        }

        // Return result if result is a number
        if let res = operations.first, Double(res) != nil {
            return Double(res)
        }

        // else return nil
        return nil
    }
}

// Extension of Array
extension Array where Element: Equatable {
    // Return first index of multiple elements of an array type variable
    func firstIndex(of items: [Element]) -> Int? {
        var result: [Int] = []

        // Search first index od each searched elements
        for item in items {
            if let opExist = self.firstIndex(of: item) {
                result.append(opExist)
            }
        }

        // Return the lower index
        return result.min()
    }
}

// Extension of Double
extension Double {
    // Return double in elegant string (2.0 become 2, 2.5 still 2.5)
    var toString: String {
        let str = String(self)
        return str.range(of: #"\.0$"#, options: .regularExpression) != nil ? String(str.dropLast(2)) : str
//        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
