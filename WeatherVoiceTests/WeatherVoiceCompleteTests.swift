//
//  WeatherVoiceCompleteTests.swift
//  WeatherVoiceTests
//
//  Created by Ed Negro on 09.10.18.
//  Copyright © 2018 Etienne Negro. All rights reserved.
//

import XCTest
@testable import WeatherVoice

class WeatherVoiceCompleteTests: XCTestCase {

    var viewController: WeatherVoice.ViewController!
    let mockVoiceManager = MockVoiceManager()
    var mockViewManager: MockViewManager!

    override func setUp() {

        if let window = UIApplication.shared.delegate?.window {
            if let rootViewController = window?.rootViewController {
                if(rootViewController is WeatherVoice.ViewController) {
                    viewController = rootViewController as? WeatherVoice.ViewController
                    viewController.voiceManager = mockVoiceManager
                    mockVoiceManager.delegate = viewController

                    mockViewManager = MockViewManager(askLabel: viewController.askLabel, weatherView: viewController.weatherView)

                    viewController.viewManager = mockViewManager
                }
            }
        }
    }

    func testExample() {
        mockViewManager.temperaturExpection = self.expectation(description: "Temperature displayed")
        mockViewManager.descExpectation = self.expectation(description: "Description displayed")
        mockViewManager.humidExpectation = self.expectation(description: "Humidity displayed")
        mockViewManager.windExpectation = self.expectation(description: "Wind displayed")
        mockViewManager.iconExpectation = self.expectation(description: "Icon downloaded")

        viewController.didTouchUpInside()

        wait(for: [mockViewManager.temperaturExpection,
            mockViewManager.descExpectation,
            mockViewManager.humidExpectation,
            mockViewManager.windExpectation,
            mockViewManager.iconExpectation], timeout: 5)
    }

}
