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

    let jsonString = """
        {"coord":{"lon":13.34,"lat":52.49},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04d"}],"base":"stations","main":{"temp":7,"pressure":1026,"humidity":87,"temp_min":10,"temp_max":11},"visibility":10000,"wind":{"speed":4.1,"deg":250},"clouds":{"all":75},"dt":1538643000,"sys":{"type":1,"id":4892,"message":0.0021,"country":"DE","sunrise":1538629995,"sunset":1538670980},"id":7290254,"name":"Berlin Schoeneberg","cod":200}
        """

    // Check if the created model contains the right values
    func testModelCreation() {
        let data = jsonString.data(using: .utf8)!
        let model = try! JSONDecoder().decode(Weather.self, from: data)

        assert(model.tempC == 7)
        assert(model.humidity == 87)
        assert(model.windspeedMps == 4.1)
        assert(model.type == "Clouds")
        assert(model.desc == "broken clouds")
        assert(model.name == "Berlin Schoeneberg")
        assert(model.icon == "04d")
    }
}
