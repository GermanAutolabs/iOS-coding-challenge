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
    func presentWelcomeMessage()
    func presentWeatherMessage(response: AssistantViewModels.Response)
}

class AssistantInteractor {
    
    // MARK: - Properties
    var presenter: AssistantInteractorOut?
    var voiceListener = VoiceListener()
    var worker = WeatherWorker()
    
    // MARK: - Methods
    func startListeningToUserAndRecognizingWords() {
        self.voiceListener.startListening(completionHandler: {
            (recognizedWord: String) in
            //print(recognizedWord)
            if recognizedWord.lowercased() == "weather" {
                self.worker.fetchCurrentWeather(completionHandler: {
                    (getWeatherResponse: GetWeatherResponse?, success: Bool) in
                    self.interpretFetchCurrentWeatherResponse(getWeatherResponse: getWeatherResponse, success: success)
                })
            }
        })
    }
    
    func interpretFetchCurrentWeatherResponse(getWeatherResponse: GetWeatherResponse?, success: Bool) {
        if let getWeatherResponse = getWeatherResponse, success {
            let main = getWeatherResponse.main
            let response = AssistantViewModels.Response(temperature: main.temp, pressure: main.pressure, humidity: main.humidity)
            self.presenter?.presentWeatherMessage(response: response)
        }
        else {
            
        }
    }
}

// MARK: - AssistantInteractorIn
extension AssistantInteractor: AssistantInteractorIn {
    func executeTasksWaitingViewToLoad() {
        presenter?.presentWelcomeMessage()
        voiceListener.setupVoiceListening(completionHandler: {
            (isSuccessful: Bool) in
            if isSuccessful {
                self.startListeningToUserAndRecognizingWords()
            }
        })
    }
}
