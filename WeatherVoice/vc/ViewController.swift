//
//  ViewController.swift
//  WeatherVoice
//
//  Created by Ed Negro on 02.10.18.
//  Copyright © 2018 Etienne Negro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherTemperatur: UILabel!

    @IBOutlet weak var weatherTempFeel: UILabel!
    @IBOutlet weak var weatherWindSpeed: UILabel!
    @IBOutlet weak var weatherHumidity: UILabel!

    @IBOutlet weak var askLabel: UILabel!

    let connectionManager: Connection = ConnectionManager()
    let voiceManager: VoiceManager = VoiceManager()

    var recognized = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        voiceManager.delegate = { text in
            self.askLabel.text = text
            self.recognized = text
        }

    }

    @IBAction func micButtoPressed(_ sender: Any) {
        voiceManager.startRecording()
        self.askLabel.text = ""
        
        (sender as! UIButton).layer.borderColor = UIColor.red.cgColor
        (sender as! UIButton).layer.borderWidth = 2.0
        
    }

    @IBAction func micButtonUp(_ sender: Any) {
        voiceManager.stopRecording()
        
        (sender as! UIButton).layer.borderWidth = 0

        if self.recognized.contains("weather") || self.recognized.contains("wetter") {

            let location = getLocationFrom(input: self.recognized)
            
            connectionManager.getWeatherInfo(location: location, date: "today") { (weather) in
                if weather != nil {
                    self.fillViewWithWeather(weather: weather!)
                }
            }
        }
    }

    func getLocationFrom (input: String) -> String {
        if let range = input.range(of: "in ") {
            let city = input[range.upperBound...]
            return String(city)
        }

        return "Berlin"
    }

    func fillViewWithWeather (weather: Weather) {
        self.weatherTemperatur.isHidden = false
        self.weatherTemperatur.text = "\(String(describing: weather.tempC)) °C"

        self.weatherDescription.isHidden = false
        self.weatherDescription.text = weather.desc

        self.weatherTempFeel.isHidden = false
        self.weatherTempFeel.text = "\(String(describing: weather.tempFeelsC)) °C"

        self.weatherWindSpeed.isHidden = false
        self.weatherWindSpeed.text = "\(String(describing: weather.windspeedKmph)) kmph"

        self.weatherHumidity.isHidden = false
        self.weatherHumidity.text = "\(String(describing: weather.humidity)) %"

        self.weatherImage.isHidden = false
        connectionManager.getIconForWeather(iconUrl: weather.icon) { (icon) in
            self.weatherImage.image = icon
        }
    }

}

