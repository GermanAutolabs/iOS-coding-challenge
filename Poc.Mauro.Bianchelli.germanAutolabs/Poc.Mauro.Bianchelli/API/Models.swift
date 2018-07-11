//
//  CityWeatherModel.swift
//  Challenge.Mauro
//
//  Created by Mauro on 4/5/18.
//  Copyright © 2018 Mauro. All rights reserved.
//

import Foundation


struct CityWeather: Decodable {
    let weather: [Weather]
    let name: String
}

struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    
}



