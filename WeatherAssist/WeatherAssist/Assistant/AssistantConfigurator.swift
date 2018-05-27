//
//  AssistantConfigurator.swift
//  WeatherAssist
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

extension AssistantViewController: AssistantPresenterOut {
}

extension AssistantInteractor: AssistantViewControllerOut {
}

extension AssistantPresenter: AssistantInteractorOut {
}

class AssistantConfigurator {
    
    // MARK: - Properties
    static let sharedInstance = AssistantConfigurator()
    
    private init() {}
    
    // MARK: - Methods
    func configure(viewController: AssistantViewController) {
        let presenter = AssistantPresenter()
        presenter.viewController = viewController
        
        let interactor = AssistantInteractor()
        interactor.presenter = presenter
        
        viewController.interactor = interactor
    }
}
