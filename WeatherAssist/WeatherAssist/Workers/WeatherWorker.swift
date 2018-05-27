//
//  WeatherWorker.swift
//  WeatherAssist
//
//  Created by Bassel Ezzeddine on 27/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

class WeatherWorker {
    
    // MARK: - Properties
    var service = WeatherService()
    
    // MARK: - Methods
    func fetchCurrentWeather(completionHandler: @escaping(_ getWeatherResponse: GetWeatherResponse?, _ success: Bool) -> Void) {
        service.getWeather(completionHandler: {
            (getWeatherResponse: GetWeatherResponse?, httpStatusCode: Int) in
            var success = false
            if httpStatusCode == 200 {
                success = true
            }
            completionHandler(getWeatherResponse, success)
        })
    }
}
