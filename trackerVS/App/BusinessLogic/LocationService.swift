//
//  LocationService.swift
//  trackerVS
//
//  Created by Home on 26.04.2022.
//

import Foundation
import GoogleMaps

final class LocationService: NSObject {
    private let locationManager = CLLocationManager()
    
    private(set) var currentLocation = Observable<CLLocationCoordinate2D?>(nil)
    
    override init() {
        super.init()
        configurLocationManager()
    }
    
    func startLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocation() {
        locationManager.stopUpdatingLocation()
    }
    
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    private func configurLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.allowsBackgroundLocationUpdates = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation.value = location.coordinate
        print("location:: \(location.coordinate)")
//        routePath?.add(location.coordinate)
//        route?.path = routePath
//
//        let position = GMSCameraPosition.camera(withTarget: location.coordinate , zoom: 15)
//        mapHolderView.animate(to: position)        
//
//        addMarker(location.coordinate)
    }
}
