//
//  ViewControllerCoordinator.swift
//  Poc.Mauro.Bianchelli
//
//  Created by Mauro on 07/7/18.
//  Copyright © 2018 Mauro. All rights reserved.
//

import Foundation
import UIKit
import Moya


class VoiceCoordinator {
    let presenter: UINavigationController
    var voiceViewController: VoiceViewController?
    var resultCoordinator: ResultCoordinator?

    
    init(presenter: UINavigationController){
        self.presenter = presenter
    }
    
    func start() {
        let st = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = st.instantiateViewController(withIdentifier: "VoiceViewController") as? VoiceViewController else{return}
        vc.delegate = self
        self.presenter.pushViewController(vc, animated: true)
    }
    
}


extension VoiceCoordinator: GoToResultProtocol{
    func goToResult(withWeather: CityWeather) {
        let resultCoordinator = ResultCoordinator(presenter: self.presenter, data: withWeather )
        resultCoordinator.start()
        

    }
    
    
}



