//
//  DetailViewController.swift
//  Poc.Mauro.Bianchelli
//
//  Created by Mauro on 07/7/18.
//  Copyright © 2018 Mauro. All rights reserved.
//

import Foundation
import UIKit

class ResultViewController: UIViewController{
    
    var weather: CityWeather?
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        label.text = weather?.name
    }
}

