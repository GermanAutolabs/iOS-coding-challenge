//
//  WeatherView.swift
//  WeatherVoice
//
//  Created by Ed Negro on 10.10.18.
//  Copyright © 2018 Etienne Negro. All rights reserved.
//

import UIKit

class WeatherView: UIView {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherTemperatur: UILabel!
    @IBOutlet weak var weatherHumidity: UILabel!
    @IBOutlet weak var weatherWindSpeed: UILabel!

    func customizeButton() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }

    func setImage(image: UIImage) {
        weatherImage.isHidden = false
        weatherImage.image = image
    }

    func setDesc(desc: String) {
        weatherDescription.isHidden = false
        weatherDescription.text = desc
    }

    func setTemperature(temp: String) {
        weatherTemperatur.isHidden = false
        weatherTemperatur.text = temp
    }

    func setHumidity(humid: String) {
        weatherHumidity.isHidden = false
        weatherHumidity.text = humid
    }

    func setWindSpeed(speed: String) {
        weatherWindSpeed.isHidden = false
        weatherWindSpeed.text = speed
    }

}
