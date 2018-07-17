//
//  Weather.swift
//  iOS coding challenge for German Autolabs
//
//  Created by Antonio De Mingo Navarro on 17/07/2018.
//  Copyright © 2018 Antonio De Mingo Navarro. All rights reserved.
//

import Foundation

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
    
    
    
    
}
