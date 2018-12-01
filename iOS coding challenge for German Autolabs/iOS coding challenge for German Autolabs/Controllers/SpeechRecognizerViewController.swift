//
//  SpeechRecognizerViewController.swift
//  iOS coding challenge for German Autolabs
//
//  Created by Antonio De Mingo Navarro on 17/07/2018.
//  Copyright © 2018 Antonio De Mingo Navarro. All rights reserved.
//

import UIKit
import CoreLocation
import Speech

class SpeechRecognizerViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var forecastImage: UIImageView!
    @IBOutlet weak var forecastLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    var cities: Set<City> = Set() {
        didSet {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }
    
    var city = City()
    
    enum SpeechStatus {
        case ready
        case recognizing
        case unavailable
    }
    
    var status = SpeechStatus.ready {
        didSet {
            self.setUI(status: status)
        }
    }
    
    var location: String = ""
    var currentWeather: [Weather] = [] {
        didSet {
            DispatchQueue.main.async {
                self.forecastLabel.text = (self.currentWeather.first?.summary)! + "\n" + "\(Int((self.currentWeather.first?.temperature)!)) ºF"
                self.title = self.city.name
            }
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        recordingButton.layer.cornerRadius = 30
        activityIndicator.startAnimating()
        parseJSON()
        requestSpeechAuthorization()
    }
    
    //MARK: - Private Methods
    func parseJSON() {
        
        let path = Bundle.main.path(forResource: "cities", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                let cities = try JSONDecoder().decode(Set<City>.self, from: data)
                self.cities = cities
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            }.resume()
    }
    
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .denied, .restricted:
                    self.status = .unavailable
                    self.textView.text = "Dictation not authorized..."
                case .authorized:
                    self.textView.text = "Tap the button to begin dictation..."
                    self.status = .ready
                case .notDetermined:
                    self.textView.text = "Speech recognition not yet authorized"
                    self.status = .unavailable
                }
            }
        }
    }
    
    func currentWeatherForLocation (location: String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    Weather.forecast(withLocation: location.coordinate, completion: { (results:[Weather]?) in
                        
                        if let weatherData = results {
                            self.currentWeather = weatherData
                        }
                    })
                }
            } else {
                print(error!)
            }
        }
    }
    
    func startRecording() {
        // Setup audio engine and speech recognizer
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        
        // Prepare and start recording
        audioEngine.prepare()
        do {
            try audioEngine.start()
            self.status = .recognizing
        } catch {
            return print(error)
        }
        
        // Analyze the speech
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                self.textView.text = result.bestTranscription.formattedString
                
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = bestString.substring(from: indexTo)
                }
                
                self.city.name = lastString
                if CharacterSet.uppercaseLetters.contains(lastString.unicodeScalars.first!) && self.cities.contains(self.city) {
                    
                    self.currentWeatherForLocation(location: self.city.name)
                }
                
            } else if let error = error {
                print(error)
            }
        })
    }
    
    func cancelRecording() {
        audioEngine.stop()
        let node = audioEngine.inputNode
        node.removeTap(onBus: 0)
        recognitionTask?.cancel()
    }
    
    func setUI(status: SpeechStatus) {
        switch status {
        case .ready:
            recordingButton.backgroundColor = UIColor.red
        case .recognizing:
            recordingButton.backgroundColor = UIColor.darkGray
        case .unavailable:
            recordingButton.backgroundColor = UIColor.darkGray
        }
    }
    
    //MARK: - Action Methods
    @IBAction func recordingButtonTapped(_ sender: UIButton) {
        switch status {
        case .ready:
            startRecording()
            status = .recognizing
        case .recognizing:
            cancelRecording()
            status = .ready
        case .unavailable:
            requestSpeechAuthorization()
            break
        }
    }
    
    //TODO: Weather Icons
    //TODO: Unit Testing
    //TODO: Separate Speech Recognition from Controller
    //TODO: Mic auth cases
    

}
