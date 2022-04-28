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
    
    private var marker: GMSMarker?
    private var route: GMSPolyline? {
        didSet {
            route?.strokeColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            route?.strokeWidth = 3
        }
    }
    private var routePath: GMSMutablePath?
    private let locationService = LocationService()
    
    private var buttonCurrentLocation: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 15.0)
        button.titleLabel?.tintColor = .black
        button.backgroundColor = .orange
        button.setTitle("Get my location", for: .normal)
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.addTarget(self, action:#selector(buttonCurrentLocationTap), for: .touchUpInside)
        return button
    }()
    private var buttonStopUpdatingLocation: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 15.0)
        button.titleLabel?.tintColor = .white
        button.backgroundColor = .brown
        button.setTitle("Stop updating location", for: .normal)
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.addTarget(self, action:#selector(buttonStopUpdatingLocationTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureUI()
        configureLocationManager()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapHolderView.pin.all()
        buttonCurrentLocation.pin.bottom(30.0).right(20.0).height(30.0).minWidth(160.0).sizeToFit()
        buttonStopUpdatingLocation.pin.bottom(30.0).left(20.0).height(30.0).minWidth(160.0).sizeToFit()
    }
    
    // MARK: - Configure
    private func configureUI() {
        mapHolderView.addSubview(buttonCurrentLocation)
        mapHolderView.addSubview(buttonStopUpdatingLocation)
    }
    
    private func configureRoutePath() {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapHolderView
    }
    
    private func configureMap() {
        view.addSubview(mapHolderView)
        
        let camera = GMSCameraPosition(target: baseCoordinates, zoom: baseZoom)
        mapHolderView.camera = camera
        mapHolderView.mapType = .normal
    }
    
    private func configureLocationManager() {
        locationService.currentLocation.addObserver(self) { [weak self] (_, _) in
            guard let self = self,
                  let currentLocation = self.locationService.currentLocation.value else { return }
            self.routePath?.add(currentLocation)
            self.route?.path = self.routePath
            
            let position = GMSCameraPosition.camera(withTarget: currentLocation , zoom: 15)
            self.mapHolderView.animate(to: position)
            //self.addMarker(currentLocation)
        }
    }
    
    // MARK: - Methods
    private func addMarker(_ coordinate: CLLocationCoordinate2D) {
        marker = GMSMarker(position: coordinate)
        marker?.map = mapHolderView
    }
    
    // MARK: - Button actions
    @objc private func buttonCurrentLocationTap(sender : UIButton) {
        configureRoutePath()
        locationService.startLocation()
    }
    
    @objc private func buttonStopUpdatingLocationTap(sender : UIButton) {
        locationService.stopLocation()
    }
}
