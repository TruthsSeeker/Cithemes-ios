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
    
    let locationWillChange = PassthroughSubject<CLLocation, Never>()
    
    @Published
    var location: CLLocation? {
        willSet {
            locationWillChange.send(newValue ?? CLLocation())
        }
    }
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestAuth() {
        self.manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        self.manager.requestLocation()
    }
}

extension LocationProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
    
    
}
