//
//  MockVoiceManager.swift
//  WeatherVoiceTests
//
//  Created by Ed Negro on 09.10.18.
//  Copyright © 2018 Etienne Negro. All rights reserved.
//

import Foundation
@testable import WeatherVoice

class MockVoiceManager: WeatherVoice.VoiceManager {
    
    override func startRecording() {}
    
    override func stopRecording() {
        self.delegate?.voiceManager(self, didRecognizeVoice: "What is the weather in Berlin")
        self.delegate?.voiceManager(self, recognisingVoice: "What is the weather in Berlin")
    }
    
    override func askSpeechPermission() {}
    
}
