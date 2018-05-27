//
//  GetWeatherResponse.swift
//  WeatherAssist
//
//  Created by Bassel Ezzeddine on 27/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

struct GetWeatherResponse: Codable, Equatable {
    var main: Main
    
    struct Main: Codable, Equatable {
        var temp: Float
        var pressure: Float
        var humidity: Float
    }
}

func ==(lhs: GetWeatherResponse, rhs: GetWeatherResponse) -> Bool {
    return lhs.main == rhs.main
}

func ==(lhs: GetWeatherResponse.Main, rhs: GetWeatherResponse.Main) -> Bool {
    return lhs.temp == rhs.temp
        && lhs.pressure == rhs.pressure
        && lhs.humidity == rhs.humidity
}
