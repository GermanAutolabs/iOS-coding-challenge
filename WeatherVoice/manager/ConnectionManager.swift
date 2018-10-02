//
//  ConnectionManager.swift
//  WeatherVoice
//
//  Created by Ed Negro on 02.10.18.
//  Copyright © 2018 Etienne Negro. All rights reserved.
//

import Alamofire
import AlamofireImage

protocol Connection {
    func getWeatherInfo(location: String, date: String, completion: @escaping (Weather?) -> Void)
    func getIconForWeather(iconUrl: String, completion: @escaping (UIImage?) -> Void)
}

class ConnectionManager: Connection {

    let baseUrl = "https://api.worldweatheronline.com"
    let apiKey = "b1928ca6bdec4310953195111180110"

    func getWeatherInfo(location: String, date: String, completion: @escaping (Weather?) -> Void) {

        let params = ["format": "json",
            "q": location,
            "key": apiKey,
            "date": date]

        Alamofire.request("\(baseUrl)/premium/v1/weather.ashx", parameters: params).responseJSON { response in
            response.result.ifSuccess {
                if let current: Dictionary<String, Any> = self.extractCurrent(json: response.result.value as! Dictionary<String, Any>) {
                    completion(self.createWeather(_from: current))
                }
            }

            response.result.ifFailure {
                completion(nil)
                debugPrint("failed")
            }
        }
    }

    func extractCurrent(json: Dictionary<String, Any>) -> Dictionary<String, Any>? {
        if let data: Dictionary<String, Any> = json["data"] as? Dictionary<String, Any> {
            if let current = data["current_condition"] as? [[String: Any]] {
                return current[0]
            }
        }
        return nil
    }

    func createWeather (_from data: Dictionary<String, Any>) -> Weather {
        var weather = Weather()
        weather.tempC = Int(data["temp_C"] as! String) ?? 0
        weather.tempFeelsC = Int(data["FeelsLikeC"] as! String) ?? 0
        weather.humidity = Int(data["humidity"] as! String) ?? 0
        weather.windspeedKmph = Int(data["windspeedKmph"] as! String) ?? 0

        if let desc = data["weatherDesc"] as? [[String: String]] {
            weather.desc = desc[0]["value"] ?? ""
        }

        if let icon = data["weatherIconUrl"] as? [[String: String]] {
            weather.icon = icon[0]["value"] ?? ""
        }

        return weather
    }

    func getIconForWeather(iconUrl: String, completion: @escaping (UIImage?) -> Void) {
        Alamofire.request(iconUrl).responseImage { response in
            if let image = response.result.value {
                completion(image)
            }
        }
    }
}
