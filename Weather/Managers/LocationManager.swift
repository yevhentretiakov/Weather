//
//  LocationManager.swift
//  Weather
//
//  Created by user on 09.06.2022.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
}

class LocationManager: NSObject {
    
    private let manager = CLLocationManager()
    
    static let shared = LocationManager()
    
    var currentLocation = CLLocation()
    
    let geoCoder = CLGeocoder()
    
    var delegate: LocationManagerDelegate?
    
    private override init() {
        super.init()
        manager.delegate = self
    }
    
    func start() {
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }
    
    func stop() {
        manager.stopUpdatingLocation()
        print("Location updation stopped.")
    }
    
    func fetchCity() async throws -> City? {
        
        let placemark = try await geoCoder.reverseGeocodeLocation(currentLocation)
        
        let firstPlace = placemark.first
        
        let city = firstPlace?.subAdministrativeArea
        let country = firstPlace?.country
        
        if let city = city, let country = country {
            return City(name: city, country: Country(name: country, localizedName: nil), localizedName: nil)
        } else {
            return nil
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.currentLocation = location
        delegate?.locationManager(manager, didUpdateLocations: locations)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .denied || status == .restricted {
            LocationManager.shared.stop()
        }
    }
}
