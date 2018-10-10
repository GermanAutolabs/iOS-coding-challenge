//
//  MockViewManager.swift
//  WeatherVoice
//
//  Created by Ed Negro on 10.10.18.
//  Copyright © 2018 Etienne Negro. All rights reserved.
//

import UIKit
import XCTest
@testable import WeatherVoice

class MockViewManager: WeatherVoice.ViewManager {
    var temperaturExpection: XCTestExpectation!
    var descExpectation: XCTestExpectation!
    var humidExpectation: XCTestExpectation!
    var windExpectation: XCTestExpectation!

    var iconExpectation: XCTestExpectation!

    override var weather: WeatherVoice.Weather! {
        didSet {
            debugPrint(weather)
            if self.weather.tempC != -1 {
                temperaturExpection?.fulfill()
            }

            if !self.weather.desc.contains("unknown") {
                descExpectation?.fulfill()
            }

            if self.weather.humidity != -1 {
                humidExpectation?.fulfill()
            }

            if self.weather.windspeedMps != -1 {
                windExpectation?.fulfill()
            }
        }
    }

    override var weatherIcon: UIImage! {
        didSet {
            iconExpectation.fulfill()
        }
    }

}
