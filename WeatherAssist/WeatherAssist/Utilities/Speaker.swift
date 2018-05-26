//
//  Speaker.swift
//  WeatherAssist
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation
import Speech

class Speaker: NSObject {
    
    // MARK: - Properties
    var synthesizer = AVSpeechSynthesizer()
    
    // MARK: - Init
    override init() {
        super.init()
        setupAudioSessionForSpeaking()
    }
    
    // MARK: - Methods
    func speak(message: String) {
        if !synthesizer.isSpeaking {
            let utterance = AVSpeechUtterance(string: message)
            synthesizer.speak(utterance)
        }
    }
    
    func setupAudioSessionForSpeaking() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        }
        catch _ {}
    }
}
