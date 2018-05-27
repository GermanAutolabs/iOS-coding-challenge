//
//  WeatherService.swift
//  WeatherAssist
//
//  Created by Bassel Ezzeddine on 27/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation
import Alamofire

class WeatherService {
    
    // MARK: - Properties
    let servicesHelper = ServicesHelper()
    
    // MARK: - Methods
    func getWeather(completionHandler: @escaping(_ getWeatherResponse: GetWeatherResponse?, _ httpStatusCode: Int) -> Void) {
        
        let endpoint = Configuration.init().weatherEndpoint()
        let url = "\(endpoint)/data/2.5/weather?q=berlin&type=accurate&appid=e1cdd7738b9db747857959666b599c83"
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                //print(response)
                let httpResponse = self.servicesHelper.getFormattedHttpResponse(dataResponse: response)
                if let json = httpResponse.json {
                    let decoder = JSONDecoder()
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                        let getWeatherResponse = try decoder.decode(GetWeatherResponse.self, from: jsonData)
                        completionHandler(getWeatherResponse, httpResponse.httpStatusCode)
                    }
                    catch _ {
                        print("Unable to decode GetWeather response")
                    }
                }
                else {
                    completionHandler(nil, httpResponse.httpStatusCode)
                }
        }
    }
}
