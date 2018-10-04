//
//  VoiceManager.swift
//
//
//  Created by Ed Negro on 02.10.18.
//

import Foundation
import Speech

class VoiceManager {
    var status: SFSpeechRecognizerAuthorizationStatus {
        return SFSpeechRecognizer.authorizationStatus()
    }

    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    var request :SFSpeechAudioBufferRecognitionRequest!
    var recognitionTask: SFSpeechRecognitionTask?
    
    var delegate : ((String) -> Void)!

    init() {
        askSpeechPermission()
    }

    func startRecording() {
        guard status == .authorized else {
            // TODO - Show error for user
            return
        }
        
        request = SFSpeechAudioBufferRecognitionRequest()
        
        let node = audioEngine.inputNode
        node.removeTap(onBus: 0)
        
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            return print(error)
        }

        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                self.delegate(result.bestTranscription.formattedString)

            } else if let error = error {
                print(error)
            }
        })

    }

    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
    }

    func askSpeechPermission() {
        SFSpeechRecognizer.requestAuthorization { status in
            OperationQueue.main.addOperation {
                switch status {
                case .authorized:
                    self.startRecording()
                default:
                    // TODO - show error
                    break
                }
            }
        }
    }

}
