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

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherTemperatur: UILabel!

    @IBOutlet weak var weatherWindSpeed: UILabel!
    @IBOutlet weak var weatherHumidity: UILabel!

    @IBOutlet weak var askLabel: UILabel!

    @IBOutlet weak var micButton: MicButton!

    var connectionManager: Connection = ConnectionManager()
    var voiceManager: VoiceManager = VoiceManager()
    var locationManager: LocationManager = LocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        voiceManager.delegate = self
        micButton.touchDelegate = self
    }

    func fillViewWithWeather (weather: Weather?) {
        guard weather != nil else {
            showError(title: "Weather", message: "Could not find weather informations")
            return
        }
        self.weatherTemperatur.isHidden = false
        self.weatherTemperatur.text = "\(String(describing: weather!.tempC)) °C"

        self.weatherDescription.isHidden = false
        self.weatherDescription.text = "\(weather!.desc) in \(weather!.name)"

        self.weatherWindSpeed.isHidden = false
        self.weatherWindSpeed.text = "Wind:\n\(String(describing: weather!.windspeedMps)) mps"

        self.weatherHumidity.isHidden = false
        self.weatherHumidity.text = "Humidity:\n\(String(describing: weather!.humidity)) %"

        self.weatherImage.isHidden = false
        connectionManager.getIconForWeather(iconUrl: weather!.icon) { (icon) in
            self.weatherImage.image = icon
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
        self.askLabel.text = result

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
        self.askLabel.text = result
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
