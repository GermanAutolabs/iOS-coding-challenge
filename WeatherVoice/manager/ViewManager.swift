//
//  ViewManager.swift
//  WeatherVoice
//
//  Created by Ed Negro on 10.10.18.
//  Copyright © 2018 Etienne Negro. All rights reserved.
//

import UIKit

class ViewManager {

    private let askLabel: UILabel?
    private let weatherView: WeatherView?

    init(askLabel: UILabel?, weatherView: WeatherView?) {
        self.askLabel = askLabel
        self.weatherView = weatherView
    }

    var weather: Weather! {
        didSet {
            self.weatherView?.setTemperature(temp: "\(String(describing: weather.tempC)) °C")
            self.weatherView?.setDesc(desc: "\(weather.desc) in \(weather.name)")
            self.weatherView?.setHumidity(humid: "Humidity:\n\(String(describing: weather.humidity)) %")
            self.weatherView?.setWindSpeed(speed: "Wind:\n\(String(describing: weather.windspeedMps)) mps")
        }
    }

    var weatherIcon: UIImage! {
        didSet {
            self.weatherView?.setImage(image: weatherIcon)
        }
    }

    var recognizedString: String! {
        didSet {
            self.askLabel?.text = recognizedString
        }
    }

}
