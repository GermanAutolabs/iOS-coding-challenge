//
//  WeatherUseCase.swift
//  AutolabsTask
//
//  Created by Rab Gábor on 2018. 07. 24..
//  Copyright © 2018. Rab Gábor. All rights reserved.
//

import UIKit

class WeatherUseCase {

    private var webService: WebService
    private var speechProcessor: SpeechProcessor
    private var locationProvider: LocationProvider

    private var userMessage = ""

    required init(webService: WebService, speechProcessor: SpeechProcessor, locationProvider: LocationProvider) {
        self.webService = webService
        self.speechProcessor = speechProcessor
        self.locationProvider = locationProvider

        self.locationProvider.refresh()
        self.speechProcessor.startSpeechRecognition()

        self.speechProcessor.requestRecognized = { (cityName) in
            if cityName != nil {
                self.webService.request(request: WeatherByCityNameRequest(cityName: cityName!),
                                        completion: { (result) in
                                            DispatchQueue.main.async() {
                                                switch result {
                                                case .success(let response):
                                                    print(response)
                                                    guard let weather = response.weather.first else {
                                                        break
                                                    }
                                                    self.userMessage = "\(weather.main) in \(response.name)"
                                                    print("USER MESSAGE: \(self.userMessage)")
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
                                                        speechProcessor.startSpeechRecognition()
                                                    }

                                                case .failure(let error):
                                                    print(error)
                                                    speechProcessor.startSpeechRecognition()
                                                }
                                            }
                })
            } else if locationProvider.currentLocation != nil {

                let latitude = String(locationProvider.currentLocation!.latitude)
                let longitude = String(locationProvider.currentLocation!.longitude)

                self.webService.request(request: WeatherByCoordinateRequest(latitude: latitude, longitude: longitude),
                                        completion: { (result) in
                                            DispatchQueue.main.async() {
                                                switch result {
                                                case .success(let response):
                                                    print(response)
                                                    guard let weather = response.weather.first else {
                                                        break
                                                    }
                                                    self.userMessage = "\(weather.main) in \(response.name)"
                                                    print("USER MESSAGE: \(self.userMessage)")
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
                                                        speechProcessor.startSpeechRecognition()
                                                    }
                                                case .failure(let error):
                                                    print(error)
                                                    speechProcessor.startSpeechRecognition()
                                                }
                                            }
                })
            } else {
                self.userMessage = "Unknown current location"
                print("USER MESSAGE: \(self.userMessage)")
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
                    speechProcessor.startSpeechRecognition()
                }
            }
        }

        self.speechProcessor.speechRecognitionStarted = { () in
            self.userMessage = "Ask the current weather"
            print("USER MESSAGE: \(self.userMessage)")
        }

        self.speechProcessor.accessProblem = { (errorString) in
            self.userMessage = errorString
            print("USER MESSAGE: \(self.userMessage)")
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
                speechProcessor.startSpeechRecognition()
            }
        }
    }
}
