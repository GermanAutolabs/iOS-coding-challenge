//
//  Weather.swift
//  iOS coding challenge for German Autolabs
//
//  Created by Antonio De Mingo Navarro on 17/07/2018.
//  Copyright © 2018 Antonio De Mingo Navarro. All rights reserved.
//

import Foundation
import CoreLocation

struct Weather {
    let summary:String
    let icon:String
    let temperature:Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json:[String:Any]) throws {
        guard let summary = json["summary"] as? String else { throw SerializationError.missing("summary is missing") }
        guard let icon = json["icon"] as? String else { throw SerializationError.missing("icon is missing") }
        guard let temperature = json["temperature"] as? Double else { throw SerializationError.missing("temp is missing") }
        
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
    }
    
    static let basePath = "https://api.darksky.net/forecast/d2bba1adab38d52cfaa298aee4fd2634/"
    
    static func forecast (withLocation location:CLLocationCoordinate2D, completion: @escaping ([Weather]?) -> ()) {
        
        let url = basePath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecast: [Weather] = []
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        
                        if let currently = json["currently"] as? [String:Any] {
                            
                            if let weatherObject = try? Weather(json: currently) {
                                
                                forecast.append(weatherObject)
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                completion(forecast)
            }
        }
        task.resume()
    }
    
    
    
    
}
