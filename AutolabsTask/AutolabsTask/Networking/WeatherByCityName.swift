//
//  WeatherByCityName.swift
//  AutolabsTask
//
//  Created by Rab Gábor on 2018. 07. 24..
//  Copyright © 2018. Rab Gábor. All rights reserved.
//

import Foundation

extension WeatherByCityNameRequest: Request {
    typealias Resp = WeatherByCityNameResponse

    static let path: String = "weather"
    static let httpMethod: HTTPMethod = .get

    var query: [String : String] {
        return ["q" : cityName]
    }
}

extension WeatherByCityNameResponse: Response {
}
