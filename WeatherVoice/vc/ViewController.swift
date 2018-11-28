//
//  ViewController.swift
//  WeatherVoice
//
//  Created by Ed Negro on 02.10.18.
//  Copyright © 2018 Etienne Negro. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var askLabel: UILabel!
    @IBOutlet weak var weatherView: WeatherView!
    @IBOutlet weak var micButton: MicButton!

    var connectionManager: Connection = ConnectionManager()
    var voiceManager: VoiceManager = VoiceManager()
    var locationManager: LocationManager = LocationManager()
    var viewManager: ViewManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        voiceManager.delegate = self
        micButton.touchDelegate = self
        
        viewManager = ViewManager(askLabel: self.askLabel,
                          weatherView: self.weatherView)
    }

    func fillViewWithWeather (weather: Weather?) {
        guard weather != nil else {
            showError(title: "Weather", message: "Could not find weather informations")
            return
        }

        viewManager.weather = weather
        connectionManager.getIconForWeather(iconUrl: weather!.icon) { (icon) in
            self.viewManager.weatherIcon = icon
        }
    }

    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: VoiceManagerDelegate {

    func voiceManager(_ manager: VoiceManager, didRecognizeVoice result: String) {
        self.viewManager.recognizedString = result

        if result.contains("weather") || result.contains("temperatur") {

            if let loc = self.locationManager.getLocationFrom(input: result) {
                connectionManager.getWeatherInfoForName(name: loc) { (weather) in
                    self.fillViewWithWeather(weather: weather)
                }

            } else if let loc = locationManager.location {
                connectionManager.getWeatherInfoForLocation(lat: loc.latitude, lon: loc.longitude) { (weather) in
                    self.fillViewWithWeather(weather: weather)
                }
            } else {
                if !self.locationManager.locationServiceEnabled() {
                    showError(title: "Location",
                        message: "Please authorize the location service `while using the app` in your system settings")
                } else {
                    showError(title: "Location",
                        message: "Can not detemin location for weather request")
                }
            }
        }

    }

    func voiceManager(_ manager: VoiceManager, recognisingVoice result: String) {
        self.viewManager.recognizedString = result
    }

    func voiceManager(_ manager: VoiceManager, anErrorAppeared error: String) {
        self.showError(title: "Error", message: error)
    }

}

extension ViewController: MicButtonDelegate {

    func didTouchInside() {
        voiceManager.startRecording()
    }

    func didTouchUpInside() {
        voiceManager.stopRecording()
    }
}
