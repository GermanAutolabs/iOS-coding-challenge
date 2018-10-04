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
    func getWeatherInfoForName(name: String, completion: @escaping (Weather?) -> Void)
    func getWeatherInfoForLocation(lat: String, lon: String, completion: @escaping (Weather?) -> Void)
    func getIconForWeather(iconUrl: String, completion: @escaping (UIImage?) -> Void)
}

class ConnectionManager: Connection {

    let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    let apiKey = "628ffd33d46e3f03eb35aabb6680a923"

    func getWeatherInfoForName(name: String, completion: @escaping (Weather?) -> Void) {
        let params = ["units": "metric",
            "q": name,
            "APPID": apiKey]

        getWeatherInfo(params: params, completion: completion)
    }

    func getWeatherInfoForLocation(lat: String, lon: String, completion: @escaping (Weather?) -> Void) {
        let params = ["units": "metric",
            "lat": lat,
            "lon": lon,
            "APPID": apiKey]

        getWeatherInfo(params: params, completion: completion)
    }

    func getWeatherInfo(params: [String: Any], completion: @escaping (Weather?) -> Void) {
        Alamofire.request(baseUrl, parameters: params).responseJSON { response in
            response.result.ifSuccess {
                completion(self.createWeather(_from: response.result.value as! Dictionary<String, Any>))
            }

            response.result.ifFailure {
                completion(nil)
                debugPrint("failed")
            }
        }
    }

    func createWeather (_from data: Dictionary<String, Any>) -> Weather {
        var weather = Weather()

        if let desc = data["weather"] as? [[String: Any]] {
            let weatherInfo = desc[0]
            weather.type = weatherInfo["main"] as! String
            weather.desc = weatherInfo["description"] as! String
            weather.icon = weatherInfo["icon"] as! String
        }

        let mainInfo = data["main"] as! Dictionary<String, Any>
        let windInfo = data["wind"] as! Dictionary<String, Any>

        weather.tempC = Int(truncating: mainInfo["temp"] as! NSNumber)
        weather.humidity = Int(truncating: mainInfo["humidity"] as! NSNumber)
        weather.windspeedMps = Int(truncating: windInfo["speed"] as! NSNumber)

        weather.name = data["name"] as! String

        return weather
    }

    func getIconForWeather(iconUrl: String, completion: @escaping (UIImage?) -> Void) {
        Alamofire.request("http://openweathermap.org/img/w/\(iconUrl).png").responseImage { response in
            if let image = response.result.value {
                completion(image)
            }
        }
    }
}
