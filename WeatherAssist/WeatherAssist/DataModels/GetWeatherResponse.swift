//
//  GetWeatherResponse.swift
//  WeatherAssist
//
//  Created by Bassel Ezzeddine on 27/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

struct GetWeatherResponse: Codable {
    var main: Main
    
    struct Main: Codable {
        var temp: Float
        var pressure: Float
        var humidity: Float
    }
}
