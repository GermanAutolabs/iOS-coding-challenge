//
//  Error.swift
//  AutolabsTask
//
//  Created by Rab Gábor on 2018. 07. 24..
//  Copyright © 2018. Rab Gábor. All rights reserved.
//

import Foundation

struct AutolabsError {
    let code: ErrorCode
    let message: String
    let cause: Error?
}

extension AutolabsError: CustomStringConvertible {
    var description: String { return message }
}

extension AutolabsError: CustomNSError {
    var errorCode: Int { return code.rawValue }
    var errorUserInfo: [String : Any] {
        return [
            NSLocalizedDescriptionKey: message,
            NSUnderlyingErrorKey: cause as Any
        ]
    }
    static let errorDomain: String = "com.germanautolabs.task"
}

enum ErrorCode: Int {
    case invalidURL = 1
    case invalidJSON = 2
    case httpError = 3
    case configFileNotFound = 4
    case apiKeyNotFoundInConfigFile = 5
}
