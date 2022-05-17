//
//  LocationService.swift
//  trackerVS
//
//  Created by Home on 26.04.2022.
//

import GoogleMaps
import UIKit

final class LocationService: NSObject {
    private let locationManager = CLLocationManager()
    weak var viewController: UIViewController?
    var isActiveLocation = false
    
    private(set) var currentLocation = Observable<CLLocationCoordinate2D?>(nil)
    private var lastKnownLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        configurLocationManager()
    }
    
    func startLocation() {
        lastKnownLocation = currentLocation.value
        locationManager.startUpdatingLocation()
        isActiveLocation = true
    }
    
    func stopLocation() {
        locationManager.stopUpdatingLocation()
        isActiveLocation = false
    }
    
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    private func configurLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        viewController?.showError(message: error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last,
              location.coordinate != lastKnownLocation,
              isActiveLocation
        else { return }
        currentLocation.value = location.coordinate
        print("location:: \(location.coordinate)")
    }
}
