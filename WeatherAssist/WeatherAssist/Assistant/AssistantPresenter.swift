//
//  AssistantPresenter.swift
//  WeatherAssist
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

protocol AssistantPresenterIn {
}

protocol AssistantPresenterOut {
}

class AssistantPresenter {
    
    // MARK: - Properties
    var viewController: AssistantPresenterOut?
}

// MARK: - AssistantPresenterIn
extension AssistantPresenter: AssistantPresenterIn {
}
