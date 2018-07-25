//
//  AppDelegate.swift
//  AutolabsTask
//
//  Created by Rab Gábor on 2018. 07. 24..
//  Copyright © 2018. Rab Gábor. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let speechProcessor = UserSpeechProcessor()
    let locationProvider = UserLocationProvider()
    var weatherUseCase: WeatherUseCase! // To prevent ARC from releasing it

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        let config: Config
        do {
            config = try Config()
        } catch {
            print(error.localizedDescription)
            preconditionFailure(error.localizedDescription)
        }

        let weatherViewController = WeatherViewController()

        weatherUseCase = WeatherUseCase(viewController: weatherViewController,
                                        webService: OpenWeatherMapWebService(apiKey: config.apiKey),
                                        speechProcessor: speechProcessor,
                                        locationProvider: locationProvider)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = weatherViewController
        self.window?.makeKeyAndVisible()

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        speechProcessor.stopSpeechRecognition()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        speechProcessor.startSpeechRecognition()
        locationProvider.refresh()
    }
}
