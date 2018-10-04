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

    // Check if the created model contains the right values
    func testModelCreation() {
        let model = connection.createWeather(_from: reponseJson)
        assert(model.tempC == 7)
        assert(model.humidity == 87)
        assert(model.windspeedMps == 4)
        assert(model.type == "Clouds")
        assert(model.desc == "broken clouds")
        assert(model.name == "Berlin")
        assert(model.icon == "04d")
    }
}
