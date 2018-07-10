//
//  ViewController.swift
//  Poc.Mauro.Bianchelli
//
//  Created by Mauro on 07/7/18.
//  Copyright © 2018 Mauro. All rights reserved.
//

import UIKit
import Speech


protocol GoToResultProtocol: class {
    func goToResult(withWeather: CityWeather)
}


public class VoiceViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var animationContainer: UIView!
    @IBOutlet weak var dictateBtn: UIButton!
    weak var delegate: GoToResultProtocol?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "de"))!
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    var cityFounded = false
    
    override public func viewDidLoad() {
        dictateBtn.isEnabled = false

    }
    
    override public func viewDidAppear(_ animated: Bool) {
        speechRecognizer.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            OperationQueue.main.addOperation {
                switch authStatus{
                case .authorized:
                    self.dictateBtn.isEnabled = true
                case .denied:
                    self.dictateBtn.isEnabled = false
                case .restricted:
                    self.dictateBtn.isEnabled = false
                case .notDetermined:
                    self.dictateBtn.isEnabled = false
                }
            }
        }
        
    Helper.initAnimation(view: animationContainer)
        
    }
    
    
    
    @IBAction func hearAction(_ sender: Any) {
        if audioEngine.isRunning {
            Helper.stopAnimating()
            audioEngine.stop()
            recognitionRequest?.endAudio()
            dictateBtn.isEnabled = false
            if cityFounded{
                self.showResult()
            }
        }else{
            try! startRecording()
            Helper.startAnimating()
        }
        
    }
    
    private func startRecording() throws{
        if let recognitionTask = recognitionTask{
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        var recognizedText = ""
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {fatalError("Unable to create object")}
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { [unowned self] (result, error) in var isFinal = false
            if let result = result{
                isFinal = result.isFinal
                print(result.bestTranscription.formattedString)
                if result.bestTranscription.formattedString.contains("Berlin"){
                    self.cityFounded = true
                }
            }
            if error != nil || isFinal{
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.dictateBtn.isEnabled = true
                
            }
            
        })
        
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 10, format: recordingFormat) { (buffer : AVAudioPCMBuffer, when:AVAudioTime) in
            self.recognitionRequest?.append(buffer )
        }
        audioEngine.prepare()
        try audioEngine.start()
        
        
    }
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available{
            dictateBtn.isEnabled = true
        }else{
            dictateBtn.isEnabled = false
        }
    }
    
    func showResult(){
        let viewModel = WeatherViewModel()
        viewModel.getWeather( completion: { [weak self] (weather) in
            guard let weather = weather else {return}
            self?.delegate?.goToResult(withWeather: weather)
        })
    }
   
    
    public override func viewDidDisappear(_ animated: Bool) {
        Helper.stopAnimating()
        self.cityFounded = false
    }
    
    
    
    
    
    
}

