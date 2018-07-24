//
//  UserLocationProvider.swift
//  AutolabsTask
//
//  Created by Rab Gábor on 2018. 07. 24..
//  Copyright © 2018. Rab Gábor. All rights reserved.
//

import Foundation
import CoreLocation

class UserLocationProvider: NSObject, LocationProvider{

    fileprivate let locationManager = CLLocationManager()

    var currentLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func refresh() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("Location not accessed")
                return
            case .authorizedAlways, .authorizedWhenInUse:
                print("Location accessed")
            }
        } else {
            print("Location services not enabled")
            return
        }

        locationManager.startUpdatingLocation()
    }
}

extension UserLocationProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        locationManager.stopUpdatingLocation()
        self.currentLocation = coordinate
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
}
