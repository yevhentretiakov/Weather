//
//  MapVC.swift
//  Weather
//
//  Created by user on 18.06.2022.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
   
    var delegate: ViewControllerDelegate?
    var coordinate: Coordinate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showCurrentLocation()
        addPin()
        configureMapView()
        configureMapTapGesture()
    }
    
    func showCurrentLocation() {
        if let safeCoordinate = coordinate {
            let longitude = safeCoordinate.longitude
            let latitude = safeCoordinate.latitude
            
            let coordinate2d = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(center: coordinate2d, span: coordinateSpan)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func addPin() {
        if let safeCoordinate = coordinate {
            let longitude = safeCoordinate.longitude
            let latitude = safeCoordinate.latitude
            
            let coordinate2d = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            // Add annotation:
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate2d
            
            // To show only one pin while tapping on map by removing the last
            if mapView.annotations.count == 1 {
                mapView.removeAnnotation(mapView.annotations.last!)
            }
            mapView.addAnnotation(annotation)
        }
    }
    
    func configureMapView() {
        mapView.delegate = self
    }
    
    func configureMapTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(gestureReconizer: UITapGestureRecognizer) {
        
        let point = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        let locationLong = coordinate.longitude
        let locationLati = coordinate.latitude
        let loc = CLLocation(latitude: locationLati, longitude: locationLong)
        
        Task {
            do {
                let area = try await LocationManager.shared.fetchArea(location: loc)
                print(area)
                delegate?.didSelectArea(area: area)
                dismiss(animated: true)
            } catch {
                if let error = error as? ErrorMessage {
                    presentAlert(message: error)
                }
            }
        }
    }
    
    // NavigationBar buttons methods
    @IBAction func showCurrentLocation(_ sender: UIButton) {
        impactOccured(style: .light)
        showCurrentLocation()
    }
    
    @IBAction func dismissVC(_ sender: UIButton) {
        impactOccured(style: .light)
        dismiss(animated: true)
    }
}


// MARK: - MKMapViewDelegate
extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
           return nil
       }
               
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
               
       if annotationView == nil {
           annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
           annotationView!.canShowCallout = true
       }
       else {
           annotationView!.annotation = annotation
       }
       
       let pinImage = UIImage(named: "mappin")
       annotationView!.image = pinImage

      return annotationView
    }
}
