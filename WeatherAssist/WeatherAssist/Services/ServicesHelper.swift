//
//  ServicesHelper.swift
//  WeatherAssist
//
//  Created by Bassel Ezzeddine on 27/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation
import Alamofire

class ServicesHelper {
    
    struct HttpResponse {
        var json: [String : AnyObject]?
        var httpStatusCode: Int
    }
    
    // MARK: - Methods
    func getFormattedHttpResponse(dataResponse: DataResponse<Any>) -> HttpResponse {
        if let httpUrlResponse = dataResponse.response {
            if let json = dataResponse.result.value as? [String : AnyObject] { // Response is json
                return HttpResponse(json: json, httpStatusCode: httpUrlResponse.statusCode)
            }
            else { // Response is not json
                return HttpResponse(json: nil, httpStatusCode: httpUrlResponse.statusCode)
            }
        }
        else { // No internet
            return HttpResponse(json: nil, httpStatusCode: 0)
        }
    }
}
