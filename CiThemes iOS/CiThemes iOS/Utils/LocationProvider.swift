//
//  LocationProvider.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 31/05/2022.
//

import Foundation
import CoreLocation
import Combine

class LocationProvider: NSObject, ObservableObject {
    let manager = CLLocationManager()
    
    @Published
    var location: CLLocation?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation() {
        if manager.authorizationStatus == .authorizedWhenInUse {
            self.manager.requestLocation()
        } else {
            self.manager.requestWhenInUseAuthorization()
        }
    }
}

extension LocationProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            self.manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        return
    }
}
