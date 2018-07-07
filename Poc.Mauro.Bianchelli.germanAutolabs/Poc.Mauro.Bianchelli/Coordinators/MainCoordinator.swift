//
//  MainCoordinator.swift
//  Poc.Mauro.Bianchelli
//
//  Created by Mauro on 07/7/18.
//  Copyright © 2018 Mauro. All rights reserved.
//

import Foundation
import UIKit

/**
 Is called from AppDelegate to start the navigation
 */
class MainCoordinator {
    var window: UIWindow?
    var rootViewController: UINavigationController
    var voiceCoordinator: VoiceCoordinator?
    
    init(window:UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        voiceCoordinator = VoiceCoordinator(presenter: rootViewController)
    }
    
    func start() {
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        voiceCoordinator?.start()
        
    }
    
}
