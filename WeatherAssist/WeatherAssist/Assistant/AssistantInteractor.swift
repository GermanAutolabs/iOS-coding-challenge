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
    func playWelcomeMessage()
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
                self.worker.fetchCurrentWeather()
            }
        })
    }
}

// MARK: - AssistantInteractorIn
extension AssistantInteractor: AssistantInteractorIn {
    func executeTasksWaitingViewToLoad() {
        presenter?.playWelcomeMessage()
        voiceListener.setupVoiceListening(completionHandler: {
            (isSuccessful: Bool) in
            if isSuccessful {
                self.startListeningToUserAndRecognizingWords()
            }
        })
    }
}
