//
//  Calculator.swift
//  CountOnMe
//
//  Created by laz on 03/07/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Calculator {
    private var operators = ["+", "-", "x", "÷"]

    var expression: String = ""
    var elements: [String] {
        return expression.split(separator: " ").map { "\($0)" }
    }

    var expressionIsCorrect: Bool {
        if elements.count % 2 == 1 {
            for (idx, value) in elements.enumerated() {
                if (idx % 2 == 0 && Float(value) == nil) || (idx % 2 == 1 && !operators.contains(value)) {
                    return false
                }
                if value == "÷" {
                    if elements.indices.contains(idx + 1) {
                        if let nextElement = Float(elements[idx + 1]), nextElement == 0 {
                            return false
                        }
                    }
                }
            }

            return true
        }
        return false
    }

    var canAddOperator: Bool {
        if let lastElement = elements.last, Float(lastElement) != nil {
            return true
        }
        return false
    }

    var result: String? {
        if let res = getResult() {
            lastResult = floatToString(res)
            return lastResult
        }
        return nil
    }

    var lastResult: String?

    private func getResult() -> Float? {

        var operations = elements

        while operations.count > 1 {
            print(operations)
            if let idx = operations.lowerIndex(of: ["x", "÷"]) ?? operations.lowerIndex(of: ["+", "-"]) {
                print(operations[idx])

                if let firstNumber = Float(operations[idx - 1]), let secondNumber = Float(operations[idx + 1]) {
                    switch operations[idx] {
                    case "x": operations[idx - 1] = "\(firstNumber * secondNumber)"
                    case "÷": operations[idx - 1] = "\(firstNumber / secondNumber)"
                    case "+": operations[idx - 1] = "\(firstNumber + secondNumber)"
                    case "-": operations[idx - 1] = "\(firstNumber - secondNumber)"
                    default: break
                    }
                }

                operations.remove(at: idx + 1)
                operations.remove(at: idx)
            }
        }

        if let res = operations.first, Float(res) != nil {
            return Float(res)
        }

        return nil
    }

    private func floatToString(_ float: Float) -> String? {
        Float(Int(float)) == float ? "\(Int(float))" : "\(float)"
    }
}

extension Array where Element: Equatable {
    func lowerIndex(of items: [Element]) -> Int? {
        var result: [Int] = []

        for item in items {
            if let opExist = self.firstIndex(of: item) {
                result.append(opExist)
            }
        }

        return result.min()
    }
}
