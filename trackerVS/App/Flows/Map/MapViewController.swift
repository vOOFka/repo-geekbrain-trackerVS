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
    private var mapHolderView = GMSMapView()
    let baseCoordinates = CLLocationCoordinate2D(latitude: 58.52107786398308, longitude: 31.275274938749853)
    var baseZoom: Float = 15.0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapHolderView.pin.all()
    }
    
    // MARK: - Methods
    func configureMap() {
        view.addSubview(mapHolderView)
        
        let camera = GMSCameraPosition(target: baseCoordinates, zoom: baseZoom)
        mapHolderView.camera = camera
        mapHolderView.mapType = .normal
    }
    
}
