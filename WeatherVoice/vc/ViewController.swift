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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func micButtoPressed(_ sender: Any) {
        askLabel.isHidden = true

        connectionManager.getWeatherInfo(location: "Berlin", date: "today") { (weather) in

            if weather != nil {
                self.weatherTemperatur.isHidden = false
                self.weatherTemperatur.text = "\(String(describing: weather!.tempC)) °C"

                self.weatherDescription.isHidden = false
                self.weatherDescription.text = weather!.desc

                self.weatherTempFeel.isHidden = false
                self.weatherTempFeel.text = "\(String(describing: weather!.tempFeelsC)) °C"

                self.weatherWindSpeed.isHidden = false
                self.weatherWindSpeed.text = "\(String(describing: weather!.windspeedKmph)) kmph"

                self.weatherHumidity.isHidden = false
                self.weatherHumidity.text = "\(String(describing: weather!.humidity)) %"
            }

        }

    }

}

