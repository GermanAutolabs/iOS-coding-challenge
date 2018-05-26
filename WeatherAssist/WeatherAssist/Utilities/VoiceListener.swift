//
//  VoiceListener.swift
//  WeatherAssist
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation
import Speech

class VoiceListener {
    
    // MARK: - Properties
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    // MARK: - Methods
    func setupVoiceListening() {
        SFSpeechRecognizer.requestAuthorization {
            [unowned self] (authStatus) in
            switch authStatus {
            case .authorized:
                self.configureListenerAndStartListening()
            case .denied:
                print("SFSpeechRecognizer authorization denied")
            case .restricted:
                print("SFSpeechRecognizer authorization restricted")
            case .notDetermined:
                print("SFSpeechRecognizer authorization not determined")
            }
        }
    }
    
    func configureListenerAndStartListening() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024,
                        format: recordingFormat) { [unowned self]
                            (buffer, _) in
                            self.request.append(buffer)
        }
        
        do {
            audioEngine.prepare()
            try audioEngine.start()
            recognitionTask = speechRecognizer?.recognitionTask(with: request) {
                (result, _) in
                if let transcription = result?.bestTranscription {
                    print(transcription.formattedString)
                }
            }
        }
        catch _ {}
    }
}
