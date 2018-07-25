//
//  WebService.swift
//  AutolabsTask
//
//  Created by Rab Gábor on 2018. 07. 24..
//  Copyright © 2018. Rab Gábor. All rights reserved.
//

import Foundation

protocol WebService {
    func request<Req: Request>(request: Req, completion: @escaping (Result<Req.Resp, AutolabsError>) -> ())
}
