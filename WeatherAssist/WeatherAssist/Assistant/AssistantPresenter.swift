//
//  AssistantPresenter.swift
//  WeatherAssist
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

protocol AssistantPresenterIn {
    func playWelcomeMessage()
}

protocol AssistantPresenterOut {
}

class AssistantPresenter {
    
    // MARK: - Properties
    var viewController: AssistantPresenterOut?
    var speaker = Speaker()
}

// MARK: - AssistantPresenterIn
extension AssistantPresenter: AssistantPresenterIn {
    func playWelcomeMessage() {
        speaker.speak(message: "Hello, please express your demand")
    }
}
