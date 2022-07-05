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
            }
            return true
        }
        return false
    }
    
    var canAddOperator: Bool {
        if let lastElement = elements.last {
            return Float(lastElement) != nil
        }
        return false
    }
    
    var result: String? {
        if let r = getResult() {
            lastResult = floatToString(r)
            return lastResult
        }
        return nil
    }
    
    var lastResult: String?

    private func getResult() -> Float? {
        
        var operations = elements
        
        while operations.count > 1 {
            var prioritiesIdx: [Int] = []
            var operatorsIdx: [Int] = []
            
            if let mulIdx = operations.firstIndex(of: "x") {
                prioritiesIdx.append(mulIdx)
            }
            
            if let divIdx = operations.firstIndex(of: "÷") {
                prioritiesIdx.append(divIdx)
            }
            
            if let plusIdx = operations.firstIndex(of: "+") {
                operatorsIdx.append(plusIdx)
            }
            
            if let minusIdx = operations.firstIndex(of: "-") {
                operatorsIdx.append(minusIdx)
            }
            
            print(operations)
            if let idx = prioritiesIdx.min() ?? operatorsIdx.min() {
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

        if let r = operations.first {
            return Float(r)
        }

        return nil
    }
    
    private func floatToString(_ float: Float) -> String? {
        Float(Int(float)) == float ? "\(Int(float))" : "\(float)"
    }
}
