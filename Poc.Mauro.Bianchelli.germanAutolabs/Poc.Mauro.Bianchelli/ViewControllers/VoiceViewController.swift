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
    func goToResult(withWeather: WeatherViewModel)
}


public class VoiceViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var animationContainer: UIView!
    @IBOutlet weak var dictateBtn: UIButton!
    weak var delegate: GoToResultProtocol?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "de"))!
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    
    override public func viewDidLoad() {
        dictateBtn.isEnabled = false
        dictateBtn.setTitle("Search for 'BERLIN' word ", for: .normal)

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
            recognitionTask?.cancel()
            audioEngine.stop()
            recognitionRequest?.endAudio()
            dictateBtn.isEnabled = false
            dictateBtn.setTitle("Search for 'BERLIN' word ", for: .normal)
            Helper.stopAnimating()
            
            
        }else{
            try! startRecording()
            Helper.startAnimating()
            dictateBtn.setTitle("Cancel", for: .normal)
        }
        
        
    }
    
    private func startRecording() throws{
        if let recognitionTask = recognitionTask{
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
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
                    self.recognitionTask?.cancel()
                    self.showResult()
                    
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
        Helper.stopAnimating()
        dictateBtn.setTitle("Search for 'BERLIN' word ", for: .normal)
        let viewModel = WeatherViewModel()
        viewModel.getWeather( completion: { [weak self] (error) in
            if error == nil{
                self?.delegate?.goToResult(withWeather: viewModel)
            }
        })
    }
   
    
    
    
    
    
    
    
}

