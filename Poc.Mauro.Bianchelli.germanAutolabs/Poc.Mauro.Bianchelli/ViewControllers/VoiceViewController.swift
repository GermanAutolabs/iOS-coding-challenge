//
//  ViewController.swift
//  Poc.Mauro.Bianchelli
//
//  Created by Mauro on 07/7/18.
//  Copyright © 2018 Mauro. All rights reserved.
//

import UIKit

protocol GoToResultProtocol: class {
    func goToResult(withWeather: CityWeather)
}


class VoiceViewController: UIViewController {
    weak var delegate: GoToResultProtocol?
    override func viewDidLoad() {
    }
    
    
    @IBAction func hearAction(_ sender: Any) {
        let viewModel = WeatherViewModel()
        viewModel.getWeather( completion: { [weak self] (weather) in
            guard let weather = weather else {return}
            self?.delegate?.goToResult(withWeather: weather)
        })
        
    }
    
    

}

