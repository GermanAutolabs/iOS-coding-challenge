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
    func setupVoiceListening(completionHandler: @escaping(_ isSuccessful: Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization {
            [unowned self] (authStatus) in
            switch authStatus {
            case .authorized:
                self.configureListener()
                completionHandler(true)
            case .denied:
                print("SFSpeechRecognizer authorization denied")
                completionHandler(false)
            case .restricted:
                print("SFSpeechRecognizer authorization restricted")
                completionHandler(false)
            case .notDetermined:
                print("SFSpeechRecognizer authorization not determined")
                completionHandler(false)
            }
        }
    }
    
    func configureListener() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024,
                        format: recordingFormat) { [unowned self]
                            (buffer, _) in
                            self.request.append(buffer)
        }
    }
    
    func startListening(completionHandler: @escaping(_ recognizedWord: String) -> Void) {
        do {
            audioEngine.prepare()
            try audioEngine.start()
            recognitionTask = speechRecognizer?.recognitionTask(with: request) {
                (result, _) in
                if let transcription = result?.bestTranscription, let lastSegment = transcription.segments.last {
                    completionHandler(lastSegment.substring)
                }
            }
        }
        catch _ {
            print("AudioEngine unable to start")
        }
    }
}
