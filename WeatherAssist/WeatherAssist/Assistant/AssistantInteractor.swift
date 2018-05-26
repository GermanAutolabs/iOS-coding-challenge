//
//  AssistantInteractor.swift
//  WeatherAssist
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

protocol AssistantInteractorIn {
    func executeTasksWaitingViewToLoad()
}

protocol AssistantInteractorOut {
}

class AssistantInteractor {
    
    // MARK: - Properties
    var presenter: AssistantInteractorOut?
    var speaker = Speaker()
    
    // MARK: - Methods
    func playWelcomeMessage() {
        speaker.speak(message: "Hello, please express your demand")
    }
}

// MARK: - AssistantInteractorIn
extension AssistantInteractor: AssistantInteractorIn {
    func executeTasksWaitingViewToLoad() {
        playWelcomeMessage()
    }
}
