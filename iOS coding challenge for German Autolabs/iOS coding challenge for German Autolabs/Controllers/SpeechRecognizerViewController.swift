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
            }
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        recordingButton.layer.cornerRadius = 30
        activityIndicator.startAnimating()
        requestSpeechAuthorization()
    }
    
    //MARK: - Private Methods
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
        
    }
    

}
