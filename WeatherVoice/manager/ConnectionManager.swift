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
    let apiKey = ""

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
        Alamofire.request(baseUrl, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                response.result.ifSuccess {

                    if let data = response.data {
                        do {
                            let weather = try JSONDecoder().decode(Weather.self, from: data)
                            completion(weather)
                        } catch {
                            completion(nil)
                            debugPrint("json parsing failed")
                        }
                    }
                }

                response.result.ifFailure {
                    completion(nil)
                    debugPrint("failed")
                }
        }
    }

    func getIconForWeather(iconUrl: String, completion: @escaping (UIImage?) -> Void) {
        Alamofire.request("http://openweathermap.org/img/w/\(iconUrl).png")
            .validate(statusCode: 200..<300)
            .responseImage { response in
                if let image = response.result.value {
                    completion(image)
                }
        }
    }
}
