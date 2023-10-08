//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Антон Закиров on 07.10.2023.
//

import XCTest

final class MovieQuizUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }

    func testGameProgress() {
        sleep(3)
        var firstPosterData = app.images["Poster"].screenshot().pngRepresentation
        var navigationLabelText = app.staticTexts["NavigationLabel"].label
        var secondPosterData: Data!
        XCTAssertEqual(navigationLabelText, "1/10")
        
        for i in 1...9 {
            if i % 2 == 0 {
                app.buttons["Yes"].tap()
            } else {
                app.buttons["No"].tap()
            }
            sleep(3)
            navigationLabelText = app.staticTexts["NavigationLabel"].label
            secondPosterData = app.images["Poster"].screenshot().pngRepresentation
            XCTAssertNotEqual(firstPosterData, secondPosterData)
            XCTAssertEqual(navigationLabelText, "\(i+1)/10")
            firstPosterData = secondPosterData
            
        }
    }
    
    func testGameFinish() {
        sleep(3)
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(3)
        }
        let alert = app.alerts["Results"]
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    
    func testGameRefresh() {
        sleep(3)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(3)
        }
        let alert = app.alerts["Results"]
        alert.buttons.firstMatch.tap()
        sleep(3)
        var navigationLabelText = app.staticTexts["NavigationLabel"].label
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(navigationLabelText == "1/10")
    }
    
}
