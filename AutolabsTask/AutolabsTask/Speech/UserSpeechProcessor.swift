//
//  UserSpeechProcessor.swift
//  AutolabsTask
//
//  Created by Rab Gábor on 2018. 07. 24..
//  Copyright © 2018. Rab Gábor. All rights reserved.
//

import Foundation
import AVFoundation
import Speech

class UserSpeechProcessor: NSObject, SpeechProcessor {

    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    var requestRecognized: ((String?) -> Void)?
    var accessProblem: ((String) -> Void)?
    var speechRecognitionStarted: (() -> Void)?

    let matchers: [(NSRegularExpression, (NSTextCheckingResult) -> [NSRange])] = [
        (try! NSRegularExpression(pattern: "weather like in (\\w+)"), { [$0.range(at: 1)] }),
        (try! NSRegularExpression(pattern: "weather in (\\w+)"), { [$0.range(at: 1)] }),
        (try! NSRegularExpression(pattern: "weather like today"), { _ in [] }),
        (try! NSRegularExpression(pattern: "weather like here"), { _ in [] }),
        (try! NSRegularExpression(pattern: "weather here"), { _ in [] }),
        (try! NSRegularExpression(pattern: "local weather"), { _ in [] }),
        (try! NSRegularExpression(pattern: "current weather"), { _ in [] }),
    ]

    func startSpeechRecognition() {
        requestAuthorizationsAndStartRecognition()
    }

    func stopSpeechRecognition() {
        if audioEngine.isRunning {
            request?.endAudio()
            audioEngine.inputNode.removeTap(onBus: 0)
            audioEngine.inputNode.reset()
            audioEngine.stop()
            recognitionTask?.cancel()
            recognitionTask = nil
            request = nil
        }
    }

    func evaluateRegex(_ bestString: String) {
        let nsBestString = bestString as NSString
        for (regex, action) in self.matchers {
            regex.enumerateMatches(in: bestString, options: [], range: NSRange(location: 0, length: nsBestString.length)) { result, _, stop in
                guard let r = result else { return }
                let ranges = action(r)
                let texts = ranges.map { nsBestString.substring(with: $0) }
                let cityName = texts.first

                stop.pointee = true

                self.stopSpeechRecognition()
                self.requestRecognized?(cityName)
            }
        }
    }

    private func requestAuthorizationsAndStartRecognition() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    switch AVAudioSession.sharedInstance().recordPermission() {
                    case AVAudioSessionRecordPermission.granted:
                        self.speechRecognitionStarted?()
                        self.startRecognition()
                    case AVAudioSessionRecordPermission.denied:
                        self.accessProblem?("No microphone access")
                    case AVAudioSessionRecordPermission.undetermined:
                        self.accessProblem?("No microphone access")
                        AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                            if granted {
                                print("Microphone access granted")
                            }
                        })
                    }
                case .denied:
                    self.accessProblem?("No access to speech recognition")
                case .restricted:
                    self.accessProblem?("Speech recognition restricted")
                case .notDetermined:
                    self.accessProblem?("Speech recognition restricted")
                }
            }
        }
    }

    private func startRecognition() {
        request = SFSpeechAudioBufferRecognitionRequest()

        guard let recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US")) else {
            print("Recognizer error")
            return
        }

        if !recognizer.isAvailable {
            print("Recognizer not available")
            self.accessProblem?("Speech recognizer not available")
            return
        }

        let node = audioEngine.inputNode
        node.removeTap(onBus: 0) // To prevent accidental crashes
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request?.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine fail")
            return print(error)
        }

        if let request = request {
            recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
                if let result = result {
                    DispatchQueue.main.async() {
                        if !self.audioEngine.isRunning {
                            return
                        }
                        let bestString = result.bestTranscription.formattedString.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

                        self.evaluateRegex(bestString)
                    }
                } else if let error = error {
                    print(error)
                }
            })
        }
    }
}
