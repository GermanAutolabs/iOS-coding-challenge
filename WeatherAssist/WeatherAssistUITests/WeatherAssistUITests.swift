//
//  WeatherAssistUITests.swift
//  WeatherAssistUITests
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import XCTest

class WeatherAssistUITests: XCTestCase {
    
    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
}
