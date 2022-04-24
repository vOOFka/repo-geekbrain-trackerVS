//
//  MapViewController.swift
//  trackerVS
//
//  Created by Home on 24.04.2022.
//

import UIKit
import GoogleMaps
import PinLayout

class MapViewController: UIViewController {
    // MARK: - Properties
    private let mapHolderView = GMSMapView()
    private let baseCoordinates = CLLocationCoordinate2D(latitude: 58.52107786398308, longitude: 31.275274938749853)
    private let baseZoom: Float = 15.0
    
    private var locationManager: CLLocationManager?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configurLocationManager()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapHolderView.pin.all()
    }
    
    // MARK: - Methods
    private func configureMap() {
        view.addSubview(mapHolderView)
        
        let camera = GMSCameraPosition(target: baseCoordinates, zoom: baseZoom)
        mapHolderView.camera = camera
        mapHolderView.mapType = .normal
    }
    
    
    
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    private func configurLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.delegate = self
        }
    }
}
