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
    
    @IBOutlet weak var imageVIew: UIImageView!
    var viewModel: WeatherViewModel?
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        label.text = viewModel?.getWeather()
        DispatchQueue.main.async {
            self.imageVIew.image = self.viewModel?.getIcon()
        }
        
    }
}

