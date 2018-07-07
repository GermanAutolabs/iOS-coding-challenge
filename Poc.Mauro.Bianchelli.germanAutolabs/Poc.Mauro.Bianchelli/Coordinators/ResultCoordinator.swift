//
//  DetailCoordinator.swift
//  Poc.Mauro.Bianchelli
//
//  Created by Mauro on 07/7/18.
//  Copyright © 2018 Mauro. All rights reserved.
//

import Foundation
import UIKit

class ResultCoordinator{
    var viewController: ResultViewController?
    let presenter: UINavigationController
    var weather: CityWeather?
    
    init(presenter:UINavigationController, data: CityWeather) {
        self.presenter = presenter
        self.weather = data
    }
    
    
    func start() {
        let st = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = st.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {return}
        self.viewController = vc
        vc.weather = weather
        presenter.pushViewController(vc, animated: true)
        
    }
}
