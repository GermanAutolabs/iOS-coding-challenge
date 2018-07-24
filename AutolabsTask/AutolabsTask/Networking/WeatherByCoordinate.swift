//
//  WeatherByCoordinate.swift
//  AutolabsTask
//
//  Created by Rab Gábor on 2018. 07. 24..
//  Copyright © 2018. Rab Gábor. All rights reserved.
//

import Foundation

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
