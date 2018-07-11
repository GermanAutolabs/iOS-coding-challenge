//
//  WeatherManager.swift
//  Challenge.Mauro
//
//  Created by Mauro on 4/5/18.
//  Copyright © 2018 Mauro. All rights reserved.
//

import Foundation
import Moya

/**
 Api resolves all the networking methods to Weather
 The API used is http://api.openweathermap.org/data/2.5/
 */
enum WeatherApi{
    case getWeather(cityName: String)
    case getIcon(id:String)
}

extension WeatherApi: TargetType{
    
    private var appId: String {
        return "69e36b63bdd890715d23b430d63e510e"
    }
    
   
    var baseURL: URL {
        return URL(fileURLWithPath: "http://api.openweathermap.org")
    }
    
    var path: String {
        switch self {
        case .getWeather(_) :
            return "/data/2.5/weather"
        case .getIcon(let id):
            return "/img/w/\(id).png"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getWeather(_), .getIcon(_):
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.queryString
    }
    
    var task: Task {
        switch self {
        case .getWeather(let cityName):
            return .requestParameters(parameters: ["q":cityName, "appId": appId], encoding: URLEncoding.queryString)
        case .getIcon(_):
            return .requestPlain
        }
    }
        
    
    var headers: [String : String]? {
        switch self {
        case .getIcon(_):
            return ["Accept" : "image/jpeg", "content-type": "image/jpeg"]
        case .getWeather(_):
            return ["Content-Type":"application/x-www-form-urlencoded"]
        }
    }
    
    
}
