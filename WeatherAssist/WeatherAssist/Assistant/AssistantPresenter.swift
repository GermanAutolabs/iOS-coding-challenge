//
//  AssistantPresenter.swift
//  WeatherAssist
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

protocol AssistantPresenterIn {
    func presentWelcomeMessage()
    func presentWeatherMessage(response: AssistantViewModels.Response)
    func presentErrorMessage()
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
    func presentWelcomeMessage() {
        speaker.speak(message: "Hello, please express your demand")
    }
    
    func presentWeatherMessage(response: AssistantViewModels.Response) {
        let weatherMessage = "Current temperature in Berlin is \(response.temperature) degrees celsius with pressure of \(response.pressure) Hectopascals and \(response.humidity) percent humidity"
        speaker.speak(message: weatherMessage)
    }
    
    func presentErrorMessage() {
        
    }
}
