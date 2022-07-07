//
//  Calculator.swift
//  CountOnMe
//
//  Created by laz on 03/07/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Calculator {
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
            for (idx, value) in elements.enumerated() {
                // Even indexes must contain number, odd indexes must contain operator
                if (idx % 2 == 0 && Float(value) == nil) || (idx % 2 == 1 && !operators.contains(value)) {
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
        for (idx, value) in elements.enumerated() where value == "÷" {
            // If next elements of ÷ is 0 return true
            if elements.indices.contains(idx + 1) {
                if let nextElement = Float(elements[idx + 1]), nextElement == 0 {
                    return true
                }
            }
        }
        return false
    }

    // Test if user can add operator
    var canAddOperator: Bool {
        // Return true, if last elements of expression is a number
        if let lastElement = elements.last, Float(lastElement) != nil {
            return true
        }
        return false
    }

    // Return the result of operation
    var result: String? {
        if let res = getResult() {
            // Save result in an other variable
            lastResult = floatToString(res)
            return lastResult
        }
        return nil
    }

    // Result of the last operation
    var lastResult: String?

    // Make the operation
    private func getResult() -> Float? {

        // Copy of elements of expression
        var operations = elements

        // While we have more than 1 element in operations array
        while operations.count > 1 {
            print(operations)
            if let idx = operations.firstIndex(of: ["x", "÷"]) ?? operations.firstIndex(of: ["+", "-"]) {
                print(operations[idx])

                // Get the numbers before and after the operator
                if let firstNumber = Float(operations[idx - 1]), let secondNumber = Float(operations[idx + 1]) {
                    // Make the operation according to operator
                    switch operations[idx] {
                    case "x": operations[idx - 1] = "\(firstNumber * secondNumber)"
                    case "÷": operations[idx - 1] = "\(firstNumber / secondNumber)"
                    case "+": operations[idx - 1] = "\(firstNumber + secondNumber)"
                    case "-": operations[idx - 1] = "\(firstNumber - secondNumber)"
                    default: break
                    }
                }

                // Remove elements of performed operation
                operations.remove(at: idx + 1)
                operations.remove(at: idx)
            }
        }

        // Return result if result is a number
        if let res = operations.first, Float(res) != nil {
            return Float(res)
        }

        // else return nil
        return nil
    }

    // Return number in elegant string (2.0 become 2, 2.5 still 2.5)
    private func floatToString(_ float: Float) -> String? {
        Float(Int(float)) == float ? "\(Int(float))" : "\(float)"
    }
}

// Extension of Array type
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
