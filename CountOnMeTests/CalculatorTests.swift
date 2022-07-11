//
//  CalculatorTests.swift
//  CountOnMeTests
//
//  Created by laz on 03/07/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

final class CalculatorTests: XCTestCase {

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

        XCTAssertEqual(calc.result, "41")
    }

    func testGivenSimpleSubstractionExpression_WhenCalculate_ThenResultIsCorrect() {
        calc.expression = "35 - 6"

        XCTAssertEqual(calc.result, "29")
    }

    func testGivenSimpleMultiplicationExpression_WhenCalculate_ThenResultIsCorrect() {
        calc.expression = "3 x 6"

        XCTAssertEqual(calc.result, "18")
    }

    func testGivenSimpleDivisionExpression_WhenCalculate_ThenResultIsCorrect() {
        calc.expression = "6 ÷ 3"

        XCTAssertEqual(calc.result, "2")
    }

    func testGivenExpressionWithPriority_WhenCalculate_ThenResultIsCorrect() {
        calc.expression = "3 + 4 x 4 - 9 ÷ 2"

        XCTAssertFalse(calc.divisionByZero)
        XCTAssertEqual(calc.result, "14.5")
    }

    func testGivenLongExpression_WhenIsValidExpression_ThenExpressionIsValid() {
        calc.expression = "3 + 4 x 4 - 8 ÷ 2"

        XCTAssertTrue(calc.expressionIsCorrect)
    }

    func testGivenExpressionWithError_WhenLastElementIsOperator_ThenExpressionIsInvalid() {
        calc.expression = "3 + 4 x 4 - 8 ÷ -"

        XCTAssertFalse(calc.expressionIsCorrect)
    }

    func testGivenExpressionWithError_WhenNumberOfElementNotCorrect_ThenExpressionIsInvalid() {
        calc.expression = "3 + 4 x 4 - 8 ÷"

        XCTAssertFalse(calc.expressionIsCorrect)
    }

    func testGivenExpression_WhenTestCanAddOperator_ThenSucess() {
        calc.expression = "3 + 4 x 4 - 8"

        XCTAssertFalse(calc.lastElementIsAnOperator)
    }

    func testGivenExpressionLastElementIsOperator_WhenTestCanAddOperator_ThenError() {
        calc.expression = "3 + 4 x 4 -"

        XCTAssertTrue(calc.lastElementIsAnOperator)
    }

    func testGivenEmptyExpression_WhenGetResult_ThenError() {
        calc.expression = ""

        XCTAssertNil(calc.result)
    }

    func testGivenExpressionWithDivisionBy0_WhenResolve_ThenErrorDivisionBy0() {
        calc.expression = "3 + 4 ÷ 0"

        XCTAssertTrue(calc.divisionByZero)
    }
}
