//
//  AssistantViewController.swift
//  WeatherAssist
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import UIKit

protocol AssistantViewControllerIn {
}

protocol AssistantViewControllerOut {
}

class AssistantViewController: UIViewController {

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - ManageInternetServicesViewControllerIn
extension AssistantViewController: AssistantViewControllerIn {
}
