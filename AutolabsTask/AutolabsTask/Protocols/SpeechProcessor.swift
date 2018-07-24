//
//  SpeechProcessor.swift
//  AutolabsTask
//
//  Created by Rab Gábor on 2018. 07. 24..
//  Copyright © 2018. Rab Gábor. All rights reserved.
//

import Foundation

protocol SpeechProcessor {
    var requestRecognized: ((String?) -> Void)? { get set }
    var accessProblem: ((String) -> Void)? { get set }

    func startSpeechRecognition()
    func stopSpeechRecognition()
}
