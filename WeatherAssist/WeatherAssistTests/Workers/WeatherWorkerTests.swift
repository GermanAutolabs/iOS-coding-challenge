//
//  WeatherWorkerTests.swift
//  WeatherAssistTests
//
//  Created by Bassel Ezzeddine on 27/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

@testable import WeatherAssist
import XCTest

class WeatherWorkerTests: XCTestCase {
    
    // MARK: - Properties
    var sut: WeatherWorker!
    
    // MARK: - Mocks
    class WeatherServiceMock: WeatherService {
        var getWeatherCalled = false
        
        override func getWeather(completionHandler: @escaping(_ getWeatherResponse: GetWeatherResponse?, _ httpStatusCode: Int) -> Void) {
            getWeatherCalled = true
        }
    }
    
    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        setupSUT()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Setup
    func setupSUT() {
        sut = WeatherWorker()
    }
    
    // MARK: - Tests
    func testCallingFetchCurrentWeather_CallsGetWeatherInService() {
        // Given
        let serviceMock = WeatherServiceMock()
        sut.service = serviceMock
        
        // When
        sut.fetchCurrentWeather()
        
        // Then
        XCTAssertTrue(serviceMock.getWeatherCalled)
    }
}
