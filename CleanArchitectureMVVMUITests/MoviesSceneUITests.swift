//
//  CleanArchitectureMVVMUITests.swift
//  CleanArchitectureMVVMUITests
//
//  Created by 김건우 on 1/20/25.
//

import XCTest

class MoviesSceneUITests: XCTestCase {
    
    override func setUp() {
        
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    // NOTE: for UI tests to work the keyboard of simulator must be on.
    // Keyboard shortchut COMMAND + SHIFT + K while simulator has focus
    func testOpenMovieDetails_whenSearchBatmanAndTapOnFirstResultRow_thenMovieDetailsViewOpensWithTitleBatman() {
        
        let app = XCUIApplication()
        
        // Search for Batman
        let searchText = "Batman Begins"
        app.searchFields[AccessibilityIdentifier.searchField].tap()
        if !app.keys["A"].waitForExistence(timeout: 5) {
            XCTFail("The keyboard could not be found. Use keyboard shortcut COMMAND + SHIFT + K while simulator has focus on text inputt")
        }
        _ = app.searchFields[AccessibilityIdentifier.searchField].waitForExistence(timeout: 10)
        app.searchFields[AccessibilityIdentifier.searchField].typeText(searchText)
        app.buttons["search"].tap()
        
        // Tap on first result row
        app.tables.cells.staticTexts[searchText].tap()
        
        // Make sure movie details view
        XCTAssertTrue(app.otherElements[AccessibilityIdentifier.movieDetailsView].waitForExistence(timeout: 10))
        XCTAssertTrue(app.navigationBars[searchText].waitForExistence(timeout: 5))
    }
    
}
