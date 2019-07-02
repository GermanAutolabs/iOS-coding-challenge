//
//  WeatherByCoordinate.swift
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

extension WeatherByCoordinateRequest: Request {
    typealias Resp = WeatherByCoordinateResponse

    static let path: String = "weather"
    static let httpMethod: HTTPMethod = .get

    var query: [String : String] {
        return ["lat" : latitude,
                "lon" : longitude]
    }
}

extension WeatherByCoordinateResponse: Response {
}
