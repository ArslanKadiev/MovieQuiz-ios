//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Арслан Кадиев on 25.06.2023.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false

        
    }

    override func tearDownWithError() throws {
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation

        let indexLabel = app.staticTexts["Index"]
       
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testGameFinish() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }

        let alert = app.alerts["Result alert"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }

    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Result alert"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }


}
//    func testScreenCast() throws {
//
//        let app = XCUIApplication()
//        app/*@START_MENU_TOKEN@*/.staticTexts["Да"]/*[[".buttons[\"Да\"].staticTexts[\"Да\"]",".staticTexts[\"Да\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.buttons["Нет"].tap()
//
//        let button = app.buttons["Да"]
//        button.tap()
//        button.tap()
//        button.tap()
//        button.tap()
//        button.tap()
//        button.tap()
//        button.tap()
//        button.tap()
//        button.tap()
//        app.alerts["Этот раунд окончен!"].scrollViews.otherElements.buttons["Сыграть еще раз"].tap()
//
//    }

//    func testExample() throws {
//
//        let app = XCUIApplication()
//        app.launch()
//
//
//    }
