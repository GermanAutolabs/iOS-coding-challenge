//
//  ViewController.swift
//  WeatherVoice
//
//  Created by Ed Negro on 02.10.18.
//  Copyright © 2018 Etienne Negro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let connectionManager: Connection = ConnectionManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        connectionManager.getWeatherInfo(location: "Berlin", date: "today") { (weather) in
            debugPrint(weather)
        }

        // Do any additional setup after loading the view, typically from a nib.
    }


}

