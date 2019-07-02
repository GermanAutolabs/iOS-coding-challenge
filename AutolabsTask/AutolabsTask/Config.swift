//
//  Config.swift
//  AutolabsTask
//
//  Created by Rab Gábor on 2018. 07. 24..
//  Copyright © 2018. Rab Gábor. All rights reserved.
//

import Foundation

struct Config {

    let apiKey: String

    init(fileName: String = "Config.plist") throws {
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
            let errorMessage =
                "\n------------------------------- Warning! -------------------------------\n"
                    + "\(fileName) not found. Please, create it according to ConfigExample.plist\n"
                    + "and provide your own OpenWeatherMap API key.\n"
                    + "------------------------------------------------------------------------\n"

            throw AutolabsError(code: .configFileNotFound,
                                message: errorMessage,
                                cause: nil)
        }
        let keyDictionary = NSDictionary(contentsOfFile: path)

        if let keyDictionary = keyDictionary, let apiKey = keyDictionary["apiKey"] as? String {
            self.apiKey = apiKey
        } else {
            let errorMessage =
                "\n------------------------------- Warning! -------------------------------\n"
                    + "Please, provide your own OpenWeatherMap API key in \(fileName)\n"
                    + "according to ConfigExample.plist\n"
                    + "------------------------------------------------------------------------\n"

            throw AutolabsError(code: .apiKeyNotFoundInConfigFile,
                                message: errorMessage,
                                cause: nil)
        }
    }
}
