//
//  AutolabsTaskTests.swift
//  AutolabsTaskTests
//
//  Created by Rab Gábor on 2018. 07. 24..
//  Copyright © 2018. Rab Gábor. All rights reserved.
//

import XCTest
import CoreLocation
@testable import AutolabsTask

class MockUserSpeechProcessor: UserSpeechProcessor {
    override func startSpeechRecognition() { }

    func startSpeechRecognition(_ text: String) {
        self.speechRecognitionStarted?()
        self.evaluateRegex(text)
    }
}

class MockUserLocationProvider: UserLocationProvider {
    override func refresh() {
        self.currentLocation = CLLocationCoordinate2D(latitude: 47.49801, longitude: 19.03991)
    }
}

class UseCaseSpy: WeatherUseCase {
    var londonExpactation: XCTestExpectation?
    var budapestExpactation: XCTestExpectation?

    override var userMessage: String {
        didSet {
            if userMessage.hasSuffix(" in London") {
                londonExpactation?.fulfill()
            }
            else if userMessage.hasSuffix(" in Budapest") {
                budapestExpactation?.fulfill()
            }
            self.viewController.userMessageLabel.text = userMessage
        }
    }
}

class AutolabsTaskTests: XCTestCase {

    var mockSpeechProcessor: MockUserSpeechProcessor!
    var webService: OpenWeatherMapWebService!
    var mockLocationProvider: MockUserLocationProvider!
    var useCase: UseCaseSpy!
    var viewController: WeatherViewController!

    override func setUp() {
        super.setUp()

        let config: Config
        do {
            config = try Config()
        } catch {
            print(error.localizedDescription)
            preconditionFailure(error.localizedDescription)
        }

        mockSpeechProcessor = MockUserSpeechProcessor()
        webService = OpenWeatherMapWebService(apiKey: config.apiKey)
        mockLocationProvider = MockUserLocationProvider()
        viewController = WeatherViewController()

        useCase = UseCaseSpy(viewController: viewController,
                              webService: webService,
                              speechProcessor: mockSpeechProcessor,
                              locationProvider: mockLocationProvider)
    }
    
    override func tearDown() {
        mockSpeechProcessor = nil
        webService = nil
        mockLocationProvider = nil
        viewController = nil
        useCase = nil

        super.tearDown()
    }
    
    func testCityBasedWeatherFetch() {
        let expectation = self.expectation(description: "London weather displayed")
        useCase.londonExpactation = expectation

        mockSpeechProcessor.startSpeechRecognition("What's the weather in London")

        wait(for: [expectation], timeout: 1.5)
    }

    func testLocalWeatherFetch() {
        let expectation = self.expectation(description: "Budapest weather displayed")
        useCase.budapestExpactation = expectation

        mockSpeechProcessor.startSpeechRecognition("What's the weather here")

        wait(for: [expectation], timeout: 1.5)
    }
}
