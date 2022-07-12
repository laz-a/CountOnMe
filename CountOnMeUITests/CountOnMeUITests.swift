//
//  CountOnMeUITests.swift
//  CountOnMeUITests
//
//  Created by laz on 11/07/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import XCTest

class CountOnMeUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test.
        // Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()
    }

    func testGivenExpression_WhenEqualButtonTapped_ThenTextViwContainExpressionWithResult() {
        // Use recording to get started writing UI tests.
        app.buttons["5"].tap()
        app.buttons["x"].tap()
        app.buttons["4"].tap()
        app.buttons["-"].tap()
        app.buttons["6"].tap()
        app.buttons["="].tap()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(app.textViews.element.value as? String, "5 x 4 - 6 = 14")
    }

    func testGivenExpression_WhenClearButtonTapped_ThenTextViewIsEmpty() {
        // Use recording to get started writing UI tests.
        app.buttons["5"].tap()
        app.buttons["x"].tap()
        app.buttons["4"].tap()
        app.buttons["AC"].tap()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(app.textViews.element.value as? String, "")
    }

    func testGivenComplexExpression_WhenEqualButtonTapped_ThenTextViwContainExpressionWithResult() {
        // Use recording to get started writing UI tests.
        app.buttons["5"].tap()
        app.buttons["6"].tap()
        app.buttons["x"].tap()
        app.buttons["+"].tap()
        app.buttons["0"].tap()
        app.buttons["0"].tap()
        app.buttons["4"].tap()
        app.buttons["="].tap()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(app.textViews.element.value as? String, "56 + 4 = 60")
    }

    func testGivenUsePrevResult_WhenEqualButtonTapped_ThenTextViwContainExpressionWithResult() {
        // Use recording to get started writing UI tests.
        app.buttons["5"].tap()
        app.buttons["x"].tap()
        app.buttons["6"].tap()
        app.buttons["="].tap()
        app.buttons["+"].tap()
        app.buttons["3"].tap()
        app.buttons["="].tap()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(app.textViews.element.value as? String, "30 + 3 = 33")
    }

    func testGivenNoUsePrevResult_WhenEqualButtonTapped_ThenTextViwContainExpressionWithResult() {
        // Use recording to get started writing UI tests.
        app.buttons["5"].tap()
        app.buttons["x"].tap()
        app.buttons["6"].tap()
        app.buttons["="].tap()
        app.buttons["6"].tap()
        app.buttons["+"].tap()
        app.buttons["3"].tap()
        app.buttons["="].tap()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(app.textViews.element.value as? String, "6 + 3 = 9")
    }

    func testGivenErrorExpression_WhenEqualButtonTapped_ThenAlertError() {
        // Use recording to get started writing UI tests.
        app.buttons["5"].tap()
        app.buttons["x"].tap()
        app.buttons["="].tap()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(app.alerts.element.label, "Expression incorrecte")
    }

    func testGivenExpressionWithDivisonBy0_WhenEqualButtonTapped_ThenAlertError() {
        // Use recording to get started writing UI tests.
        app.buttons["5"].tap()
        app.buttons["÷"].tap()
        app.buttons["0"].tap()
        app.buttons["="].tap()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(app.alerts.element.label, "Division par zéro")
    }
}
