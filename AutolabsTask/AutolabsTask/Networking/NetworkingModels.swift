//
//  NetworkingModels.swift
//  AutolabsTask
//
//  Created by Rab Gábor on 2018. 07. 24..
//  Copyright © 2018. Rab Gábor. All rights reserved.
//

import Foundation

struct WeatherByCoordinateRequest: Codable {
    let latitude: String
    let longitude: String
}

struct WeatherByCoordinateResponse: Codable {
    let weather: [Weather]
    let name: String
}

struct WeatherByCityNameRequest: Codable {
    let cityName: String
}

struct WeatherByCityNameResponse: Codable {
    let weather: [Weather]
    let name: String
}
