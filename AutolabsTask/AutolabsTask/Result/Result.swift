//
//  Result.swift
//  AutolabsTask
//
//  Created by Rab Gábor on 2018. 07. 24..
//  Copyright © 2018. Rab Gábor. All rights reserved.
//

import Foundation

public enum Result<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)

    public init(value: Value) {
        self = .success(value)
    }

    public init(error: Error) {
        self = .failure(error)
    }
}
