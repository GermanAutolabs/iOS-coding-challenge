//
//  WeatherServiceTests.swift
//  WeatherAssistTests
//
//  Created by Bassel Ezzeddine on 27/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

@testable import WeatherAssist
import XCTest

class WeatherServiceTests: XCTestCase {
    
    // MARK: - Properties
    var sut: WeatherService!
    let mockServer = MockServer()
    
    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        setupSUT()
    }
    
    override func tearDown() {
        sut = nil
        mockServer.stop()
        super.tearDown()
    }
    
    // MARK: - Setup
    func setupSUT() {
        sut = WeatherService()
    }
    
    // MARK: - Tests
    func testCallingGetWeather_ReturnsCorrectData() {
        // Given
        mockServer.respondToGetWeather()
        mockServer.start()
        
        // When
        let expectation = self.expectation(description: "Wait server response")
        sut.getWeather(completionHandler: {
            (getWeatherResponse: GetWeatherResponse?, httpStatusCode: Int) in
            
            // Then
            XCTAssertEqual(httpStatusCode, 200)
            XCTAssertNotNil(getWeatherResponse)
            XCTAssertEqual(getWeatherResponse?.main.temp, 25)
            XCTAssertEqual(getWeatherResponse?.main.pressure, 1000)
            XCTAssertEqual(getWeatherResponse?.main.humidity, 50)
            
            expectation.fulfill()
        })
        self.waitForExpectations(timeout: 3.0, handler: nil)
    }
}
