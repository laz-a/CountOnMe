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
        XCTAssertEqual(calc.expression, "")
    }

    func testGivenNoExpression_WhenCreateExpression_ThenExpressionIsConvertToArrayOfElements() {
        calc.addNumber("44")
        calc.addOperator("+")
        calc.addNumber("33")

        XCTAssertEqual(calc.expression, "44 + 33")
//        XCTAssertEqual(calc.elements, ["44", "+", "33"])
    }

    func testGivenSimpleAddition_WhenCalculate_ThenResultIsCorrect() {
        calc.addNumber("35")
        calc.addOperator("+")
        calc.addNumber("6")
        try? calc.result()

        XCTAssertEqual(calc.expression, "35 + 6 = 41")
    }

    func testGivenSimpleSubstraction_WhenCalculate_ThenResultIsCorrect() {
        calc.addNumber("35")
        calc.addOperator("-")
        calc.addNumber("6")
        try? calc.result()

        XCTAssertEqual(calc.expression, "35 - 6 = 29")
    }

    func testGivenSimpleMultiplication_WhenCalculate_ThenResultIsCorrect() {
        calc.addNumber("3")
        calc.addOperator("x")
        calc.addNumber("6")
        try? calc.result()

        XCTAssertEqual(calc.expression, "3 x 6 = 18")
    }

    func testGivenSimpleDivision_WhenCalculate_ThenResultIsCorrect() {
        calc.addNumber("6")
        calc.addOperator("÷")
        calc.addNumber("3")
        try? calc.result()

        XCTAssertEqual(calc.expression, "6 ÷ 3 = 2")
    }

    func testGivenExpressionWithPriority_WhenCalculate_ThenResultIsCorrect() {
        calc.addNumber("3")
        calc.addOperator("+")
        calc.addNumber("4")
        calc.addOperator("x")
        calc.addNumber("4")
        calc.addOperator("-")
        calc.addNumber("9")
        calc.addOperator("÷")
        calc.addNumber("2")
        try? calc.result()

        XCTAssertEqual(calc.expression, "3 + 4 x 4 - 9 ÷ 2 = 14.5")
    }

    func testGivenChangeOperatorExpression_WhenGetExpression_ThenExpressionIsCorrect() {
        calc.addNumber("3")
        calc.addOperator("+")
        calc.addOperator("x")
        calc.addNumber("0")
        calc.addNumber("0")
        calc.addNumber("6")
        try? calc.result()

        XCTAssertEqual(calc.expression, "3 x 6 = 18")
    }

    func testGivenExpression_WhenUsePrevResult_ThenExpressionIsCorrect() {
        calc.addNumber("6")
        calc.addOperator("÷")
        calc.addNumber("3")
        try? calc.result()
        calc.addOperator("x")
        calc.addNumber("2")
        try? calc.result()

        XCTAssertEqual(calc.expression, "2 x 2 = 4")
    }

    func testGivenExpression_WhenNewExpression_ThenExpressionIsCorrect() {
        calc.addNumber("6")
        calc.addOperator("÷")
        calc.addNumber("3")
        try? calc.result()
        calc.addNumber("3")
        calc.addOperator("x")
        calc.addNumber("2")
        try? calc.result()

        XCTAssertEqual(calc.expression, "3 x 2 = 6")
    }

    func testGivenExpression_WhenStartWithOperator_ThenExpressionIsCorrect() {
        calc.addOperator("x")
        calc.addNumber("6")
        calc.addOperator("x")
        calc.addNumber("3")
        try? calc.result()

        XCTAssertEqual(calc.expression, "6 x 3 = 18")
    }

    func testGivenErrorExpression_WhenGetresult_ThenErrorIncorrectExpression() {
        calc.addNumber("3")
        calc.addOperator("+")
        calc.addNumber("4")
        calc.addOperator("x")

        XCTAssertThrowsError(try calc.result(), "Error incorrect expression") { error in
            XCTAssertEqual(error as? CalcError, CalcError.incorrectExpression)
        }
    }

    func testGivenExpressionWithDivisionBy0_WhenGetResult_ThenErrorDivisionBy0() {
        calc.addNumber("3")
        calc.addOperator("+")
        calc.addNumber("4")
        calc.addOperator("÷")
        calc.addNumber("0")

        XCTAssertThrowsError(try calc.result(), "Error division by 0") { error in
            XCTAssertEqual(error as? CalcError, CalcError.divisionByZero)
        }
    }

    func testGivenExpression_WhenClearExpression_ThenExpressionIsEmpty() {
        calc.addNumber("3")
        calc.addOperator("+")
        calc.addNumber("4")
        calc.clearExpression()

        XCTAssertEqual(calc.expression, "")
    }
}
