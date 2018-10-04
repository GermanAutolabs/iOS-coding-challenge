//
//  WeatherVoiceLocationTests.swift
//  WeatherVoiceTests
//
//  Created by Ed Negro on 04.10.18.
//  Copyright © 2018 Etienne Negro. All rights reserved.
//

import XCTest

class WeatherVoiceLocationTests: XCTestCase {

    let locationManager = LocationManager()

    func testCorrectVoiceInput() {
        let city = locationManager.getLocationFrom(input: "What is the weather in New York")
        assert(city == "New York")
    }

    func testNoCityInVoiceInput() {
        let city = locationManager.getLocationFrom(input: "What is the weather")
        assert(city == "Berlin")
    }

}
