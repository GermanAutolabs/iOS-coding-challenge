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
    override func startSpeechRecognition() {
        self.speechRecognitionStarted?()
        self.evaluateRegex("What's the weather in London")
    }
}

class MockUserLocationProvider: UserLocationProvider {
    override func refresh() {
        self.currentLocation = CLLocationCoordinate2D(latitude: 51.509865, longitude: -0.118092)
    }
}

class UseCaseSpy: WeatherUseCase {
    var londonExpactation: XCTestExpectation?

    override var userMessage: String {
        didSet {
            if userMessage.hasSuffix(" in London") {
                londonExpactation?.fulfill()
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
    
    func testExample() {
        let expectation = self.expectation(description: "London weather displayed")
        useCase.londonExpactation = expectation

        mockSpeechProcessor.startSpeechRecognition()

        wait(for: [expectation], timeout: 1.5)
    }
}
