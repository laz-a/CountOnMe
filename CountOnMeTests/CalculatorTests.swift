//
//  CalculatorTests.swift
//  CountOnMeTests
//
//  Created by laz on 03/07/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalculatorTests: XCTestCase {

    var calc: Calculator!
    
    override func setUp() {
        super.setUp()
        
        calc = Calculator()
    }
    
    func testGivenInstanceOfCalculator_WhenAccessingIt_ThenItExist() {
        XCTAssertNotNil(calc)
    }
    
    func testGivenNoExpression_WhenCreateExpression_ThenExpressionIsConvertToArrayOfElements() {
        calc.expression = "44 + 33"
        
        XCTAssertEqual(calc.expression, "44 + 33")
        XCTAssertEqual(calc.elements, ["44", "+", "33"])
    }
    
    func testGivenSimpleAdditionExpression_WhenCalculate_ThenResultIsCorrect() {
        calc.expression = "35 + 6"
        
        XCTAssertEqual(calc.result, 41)
    }
    
    func testGivenSimpleSubstractionExpression_WhenCalculate_ThenResultIsCorrect() {
        calc.expression = "35 - 6"
        
        XCTAssertEqual(calc.result, 29)
    }

    func testGivenSimpleMultiplicationExpression_WhenCalculate_ThenResultIsCorrect() {
        calc.expression = "3 x 6"
        
        XCTAssertEqual(calc.result, 18)
    }

    func testGivenSimpleDivisionExpression_WhenCalculate_ThenResultIsCorrect() {
        calc.expression = "6 / 3"
        
        XCTAssertEqual(calc.result, 2)
    }
    
    func testGivenExpressionWithPriority_WhenCalculate_ThenResultIsCorrect() {
        calc.expression = "3 + 4 x 4 - 8 / 2"
        
        XCTAssertEqual(calc.result, 15)
    }
    
    func testGivenExpression_WhenIsValidExpression_ThenExpressionIsValid() {
        calc.expression = "3 + 4 x 4 - 8 / 2"
        
        XCTAssertTrue(calc.expressionIsCorrect)
    }
}
