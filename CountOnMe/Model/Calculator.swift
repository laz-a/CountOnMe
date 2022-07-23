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

    // Update expression Notification -> ViewController
    private let updateExpressionNotification = Notification(name: Notification.Name(rawValue: "UpdateExpression"))

    // Expression in String format
    var expression: String = "" {
        didSet {
            // Post notification to update textView
            NotificationCenter.default.post(updateExpressionNotification)
        }
    }
    // Array of elements of String expression
    private var elements: [String] {
        return expression.split(separator: " ").map { "\($0)" }
    }

    // Result of the last operation
    private var lastResult: String? {
        // Get 2 last elements
        let lastOperation = elements.suffix(2)

        // If before last element is an =
        if lastOperation.first == "=" {
            // Return last element (result of previous expression)
            return lastOperation.last
        } else {
            return nil
        }
    }

    // Test if expression if correct
    private var expressionIsCorrect: Bool {
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
    private var divisionByZero: Bool {
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
    private var lastElementIsAnOperator: Bool {
        // Return true, if last elements of expression is an operator
        if let lastElement = elements.last, operators.contains(lastElement) {
            return true
        }
        return false
    }

    // Add number to expression
    func addNumber(_ numberText: String) {
        // If lastResult exist, clear expression
        if lastResult != nil {
            expression = ""
        }

        // Prevent to start number with multiple 0
        if elements.last == "0" {
            if numberText == "0" {
                return
            } else {
                // Ex : 05 -> 5
                expression.removeLast()
            }
        }

        // Update expression
        expression += numberText
    }
    
    // Add operator to expression
    func addOperator(_ operatorText: String) {
        // Prevent to start expression with an operator
        guard !expression.isEmpty else {
            return
        }

        // If lastResult exist, set lastResult as first element of expression
        if let lResult = lastResult {
            expression = lResult
        }

        // If last element of expression is an operator, remove this element from expression
        if lastElementIsAnOperator {
            expression.removeLast(3)
        }

        // Uptade expression
        expression += " \(operatorText) "
    }

    // Get result of expression or error
    func result() throws {

        // Return if expression is empty or where result already exist
        guard !expression.isEmpty && lastResult == nil else {
            return
        }

        // Throw error for incorrect expression
        guard expressionIsCorrect else {
            throw CalcError.incorrectExpression
        }

        // Throw error when division by 0 in expression
        guard !divisionByZero else {
            throw CalcError.divisionByZero
        }

        // Copy elements of expression in local variable
        var operations = elements

        // While we have more than 1 element in operations array
        while operations.count > 1 {
            if let idx = operations.firstIndex(of: ["x", "÷"]) ?? operations.firstIndex(of: ["+", "-"]) {
                // Get the numbers before and after the operator
                if let firstNumber = Double(operations[idx - 1]), let secondNumber = Double(operations[idx + 1]) {

                    // Make the operation according to operator
                    let result = calcul(firstNumber, operations[idx], secondNumber)

                    // Remove elements of performed operation
                    operations.replaceSubrange((idx - 1)...(idx + 1), with: ["\(result)"])
                }
            }
        }

        // If result is a number : update expression
        if let res = operations.first, let result = Double(res) {
            expression += " = \(result.toString)"
        } else {
            throw CalcError.unknowError
        }
    }
    
    // Return calculation result
    private func calcul(_ firstNumber: Double, _ operation: String, _ secondNumber: Double) -> Double {
        var result: Double
        switch operation {
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
        return result
    }

    // Clear expression
    func clearExpression() {
        expression = ""
    }
}

// Calculation errors
enum CalcError: String, Error {
    case incorrectExpression
    case divisionByZero
    case unknowError
}
extension CalcError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .incorrectExpression:
            return NSLocalizedString("Expression incorrecte", comment: "Invalid Email")
        case .divisionByZero:
            return NSLocalizedString("Division par 0", comment: "Invalid Password")
        case .unknowError:
            return NSLocalizedString("Erreur inconnue", comment: "Invalid Phone Number")
        }
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
