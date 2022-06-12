//
//  LocationManager.swift
//  Weather
//
//  Created by user on 09.06.2022.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    private let manager = CLLocationManager()
    
    static let shared = LocationManager()
    
    var currentLocation = CLLocation()
    
    let geoCoder = CLGeocoder()
    
    private override init() {
        super.init()
        manager.delegate = self
    }
    
    func start() {
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }
    
    func fetchCityName() async throws -> String? {
        let placemark = try await geoCoder.reverseGeocodeLocation(currentLocation)
        
        let firstPlace = placemark.first

        return firstPlace?.subAdministrativeArea
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Wor")
        guard let location = locations.last else { return }
        self.currentLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Fail With Error")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            print("Location On")
        }
    }
}
