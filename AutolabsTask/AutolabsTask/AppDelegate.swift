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


    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        let config: Config
        do {
            config = try Config()
        } catch {
            print(error.localizedDescription)
            preconditionFailure(error.localizedDescription)
        }

        let webService = OpenWeatherMapWebService(apiKey: config.apiKey)

        

        return true

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }


}

