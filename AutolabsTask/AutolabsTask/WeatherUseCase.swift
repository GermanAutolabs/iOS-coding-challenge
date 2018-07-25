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
    private var viewController: WeatherViewController

    private var userMessage = "" {
        didSet {
            viewController.userMessageLabel.text = userMessage
        }
    }

    private var background1Image = UIImage() {
        didSet {
            viewController.background1ImageView.image = background1Image
        }
    }

    private var background2Image = UIImage() {
        didSet {
            viewController.background2ImageView.image = background2Image
        }
    }

    private var background3Image = UIImage() {
        didSet {
            viewController.background3ImageView.image = background3Image
        }
    }

    // TODO: Expand with more options and images!
    private let backgroundImageMap = [
        "sunny" : [
            "1" : "sunny1",
            "2" : "sunny2",
            "3" : "sunny3"
        ],
        "default" : [
            "1" : "sunny1",
            "2" : "sunny2",
            "3" : "sunny3"
        ],
    ]

    required init(viewController: WeatherViewController, webService: WebService, speechProcessor: SpeechProcessor, locationProvider: LocationProvider) {
        self.viewController = viewController
        self.webService = webService
        self.speechProcessor = speechProcessor
        self.locationProvider = locationProvider

        viewController.userMessageLabel.text = "Ask the current weather..."

        viewController.background1ImageView.image = UIImage(named: self.backgroundImageMap["default"]!["1"]!)!
        viewController.background2ImageView.image = UIImage(named: self.backgroundImageMap["default"]!["2"]!)!
        viewController.background3ImageView.image = UIImage(named: self.backgroundImageMap["default"]!["3"]!)!

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
                                                    self.backgroundImageMapper(weather: weather.main.lowercased())

                                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
                                                        speechProcessor.startSpeechRecognition()
                                                    }
                                                case .failure(let error):
                                                    print(error)
                                                    self.userMessage = "Something went wrong"
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
                                                        speechProcessor.startSpeechRecognition()
                                                    }
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
                                                    self.backgroundImageMapper(weather: weather.main.lowercased())

                                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
                                                        speechProcessor.startSpeechRecognition()
                                                    }
                                                case .failure(let error):
                                                    print(error)
                                                    self.userMessage = "Something went wrong"
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
                                                        speechProcessor.startSpeechRecognition()
                                                    }
                                                }
                                            }
                })
            } else {
                self.userMessage = "Unknown current location"
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
                    speechProcessor.startSpeechRecognition()
                }
            }
        }

        self.speechProcessor.speechRecognitionStarted = { () in
            self.userMessage = "Ask the current weather..."
        }

        self.speechProcessor.accessProblem = { (errorString) in
            self.userMessage = errorString
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
                speechProcessor.startSpeechRecognition()
            }
        }
    }

    func backgroundImageMapper(weather: String) {
        if let images = self.backgroundImageMap[weather] {
            self.background1Image = UIImage(named: images["1"]!)!
            self.background2Image = UIImage(named: images["2"]!)!
            self.background3Image = UIImage(named: images["3"]!)!
        } else {
            self.background1Image = UIImage(named: self.backgroundImageMap["default"]!["1"]!)!
            self.background2Image = UIImage(named: self.backgroundImageMap["default"]!["2"]!)!
            self.background3Image = UIImage(named: self.backgroundImageMap["default"]!["3"]!)!
        }
    }
}
