//
//  LocationProvider.swift
//  AutolabsTask
//
//  Created by Rab Gábor on 2018. 07. 24..
//  Copyright © 2018. Rab Gábor. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationProvider {
    func refresh()
    var currentLocation: CLLocationCoordinate2D? { get }
}
