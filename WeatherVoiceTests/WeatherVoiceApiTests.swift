//
//  WeatherVoiceTests.swift
//  WeatherVoiceTests
//
//  Created by Ed Negro on 02.10.18.
//  Copyright © 2018 Etienne Negro. All rights reserved.
//

import XCTest
@testable import WeatherVoice

class WeatherVoiceApiTests: XCTestCase {

    var connection = ConnectionManager()
    var reponseJson: Dictionary<String, AnyObject>!

    // Serialize the weather.json to have stable data to check the model building process
    override func setUp() {
        if let path = Bundle.main.path(forResource: "weather", ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                self.reponseJson = jsonResult
            }
        }
    }

    // Check if the current condition is gathered correctly from the json
    func testGetCurrentCondition() {
        let current = connection.extractCurrent(json: reponseJson)
        assert(current != nil)
        assert(current?.keys.count == 17)
    }

    // Check if the created model contains the right values
    func testModelCreation() {
        if let current = connection.extractCurrent(json: reponseJson) {
            let model = connection.createWeather(_from: current)
            assert(model.tempC == 7)
            assert(model.tempFeelsC == 4)
            assert(model.humidity == 87)
            assert(model.windspeedKmph == 20)
            assert(model.desc == "Partly cloudy")
            assert(model.icon.count > 0)
        }
    }
}
