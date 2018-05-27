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
        var getWeatherResponseToBeReturned: GetWeatherResponse?
        var httpStatusCodeToBeReturned = 0
        
        override func getWeather(completionHandler: @escaping(_ getWeatherResponse: GetWeatherResponse?, _ httpStatusCode: Int) -> Void) {
            getWeatherCalled = true
            completionHandler(getWeatherResponseToBeReturned, httpStatusCodeToBeReturned)
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
        sut.fetchCurrentWeather(completionHandler:{_,_ in})
        
        // Then
        XCTAssertTrue(serviceMock.getWeatherCalled)
    }
    
    func testCallingFetchCurrentWeather_ReturnsCorrectDataWhenHttpStatusCodeIs200() {
        // Given
        let serviceMock = WeatherServiceMock()
        sut.service = serviceMock
        
        // When
        let main = GetWeatherResponse.Main(temp: 25, pressure: 1000, humidity: 50)
        serviceMock.getWeatherResponseToBeReturned = GetWeatherResponse(main: main)
        serviceMock.httpStatusCodeToBeReturned = 200
        
        sut.fetchCurrentWeather(completionHandler: {
            (getWeatherResponse: GetWeatherResponse?, success: Bool) in
            // Then
            XCTAssertEqual(getWeatherResponse!, GetWeatherResponse(main: main))
            XCTAssertTrue(success)
        })
    }
    
    func testCallingFetchCurrentWeather_ReturnsCorrectDataWhenHttpStatusCodeIsNot200() {
        // Given
        let serviceMock = WeatherServiceMock()
        sut.service = serviceMock
        
        // When
        serviceMock.getWeatherResponseToBeReturned = nil
        serviceMock.httpStatusCodeToBeReturned = 500
        
        sut.fetchCurrentWeather(completionHandler: {
            (getWeatherResponse: GetWeatherResponse?, success: Bool) in
            // Then
            XCTAssertEqual(getWeatherResponse, nil)
            XCTAssertFalse(success)
        })
    }
}
