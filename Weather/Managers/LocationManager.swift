//
//  LocationManager.swift
//  Weather
//
//  Created by user on 09.06.2022.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager)
}

final class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    private let geoCoder = CLGeocoder()
    
    private var lastLocation: CLLocation?
    
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
    }
    
    func fetchArea(location: CLLocation) async throws -> Area {
        
        let placemark = try await geoCoder.reverseGeocodeLocation(location)
        
        let firstPlace = placemark.first
        
        let adminArea = firstPlace?.subAdministrativeArea
        let country = firstPlace?.country
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        if adminArea != nil || country != nil {
            let coordinate = Coordinate(latitude: latitude, longitude: longitude)
            return Area(adminArea: adminArea, country: country, coordinate: coordinate)
        } else {
            throw ErrorMessage.cantGetArea
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        delegate?.locationManagerDidChangeAuthorization(manager)
    }
}
