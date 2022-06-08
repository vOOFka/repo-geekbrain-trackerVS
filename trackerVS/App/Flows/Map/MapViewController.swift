//
//  MapViewController.swift
//  trackerVS
//
//  Created by Home on 24.04.2022.
//

import UIKit
import GoogleMaps
import PinLayout
import CoreLocation
import RxSwift

final class MapViewController: UIViewController, Coordinating {
    // MARK: - Public properties
    var coordinator: Coordinator?
    
    // MARK: - Private properties
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
    
    private let realmService: RealmService = RealmServiceImplimentation()
    private var trackLocations: [CLLocationCoordinate2D] = []
    
    private var buttonStartUpdatingLocation: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 15.0)
        button.titleLabel?.tintColor = .black
        button.backgroundColor = .orange
        button.setTitle("Start a new track", for: .normal)
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.addTarget(self, action:#selector(buttonStartUpdatingLocationTap), for: .touchUpInside)
        return button
    }()
    private var buttonStopUpdatingLocation: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 15.0)
        button.titleLabel?.tintColor = .white
        button.backgroundColor = .brown
        button.setTitle("Finish the track", for: .normal)
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.addTarget(self, action:#selector(buttonStopUpdatingLocationTap), for: .touchUpInside)
        return button
    }()
    private var buttonShowPreviousRoute: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 15.0)
        button.titleLabel?.tintColor = .white
        button.backgroundColor = .systemTeal
        button.setTitle("Show the previous route", for: .normal)
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.addTarget(self, action:#selector(buttonShowPreviousRouteTap), for: .touchUpInside)
        return button
    }()
    private var buttonChangeAvatar: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        button.setImage(UIImage(systemName: "camera.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.addTarget(self, action:#selector(buttonChangeAvatarTap), for: .touchUpInside)
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
        
        buttonShowPreviousRoute.pin.bottom(120.0).right(20.0).height(30.0).minWidth(180.0).sizeToFit()
        buttonStartUpdatingLocation.pin.below(of: buttonShowPreviousRoute, aligned: .center)
            .height(30.0).marginTop(10.0).minWidth(180.0).sizeToFit()
        buttonStopUpdatingLocation.pin.below(of: buttonStartUpdatingLocation, aligned: .center)
            .height(30.0).marginTop(10.0).minWidth(180.0).sizeToFit()
        
        buttonChangeAvatar.pin.bottom(40.0).left(20.0).height(60.0).width(60.0)
    }
    
    // MARK: - Configure
    private func configureUI() {
        mapHolderView.addSubview(buttonStartUpdatingLocation)
        mapHolderView.addSubview(buttonStopUpdatingLocation)
        mapHolderView.addSubview(buttonShowPreviousRoute)
        mapHolderView.addSubview(buttonChangeAvatar)
    }
    
    private func configureRoutePath() {
        mapHolderView.clear()
        
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapHolderView
        
        cleanTrackLocations()
    }
    
    private func configureMap() {
        view.addSubview(mapHolderView)
        
        let camera = GMSCameraPosition(target: baseCoordinates, zoom: baseZoom)
        mapHolderView.camera = camera
        mapHolderView.mapType = .normal
    }
    
     private func configureLocationManager() {
        let _ = locationService
            .currentLocation
            .asObservable()
            .bind { [weak self] currentLocation in
                guard let self = self,
                      let currentLocation = currentLocation
                else {
                    return
                }
                
                self.routePath?.add(currentLocation)
                self.route?.path = self.routePath
                
                let position = GMSCameraPosition.camera(withTarget: currentLocation, zoom: 15)
                self.mapHolderView.animate(to: position)
                self.addMarker(currentLocation)
                self.trackLocations.append(currentLocation)
            }
    }
    
    // MARK: - Methods
    private func cleanTrackLocations() {
        trackLocations = []
    }

    private func addMarker(_ coordinate: CLLocationCoordinate2D) {
        marker = GMSMarker(position: coordinate)
        marker?.map = mapHolderView
    }
    
    public func cancelCurrentTracking() {
        locationService.stopLocation()
        showPreviousRoute()
    }
    
    private func showPreviousRoute() {
        configureRoutePath()
        pullFromRealm()
        
        guard !trackLocations.isEmpty,
              let firstTrackingPoint = trackLocations.first,
              let lastTrackingPoint = trackLocations.last
        else {
            showError(message: "Previous routes not found", title: "Notification")
            return
        }
        
        trackLocations.forEach { point in
            self.routePath?.add(point)
            self.route?.path = self.routePath
            self.addMarker(point)
        }
        
        let cameraUpdate = GMSCameraUpdate.fit(
            GMSCoordinateBounds(coordinate: firstTrackingPoint,
                                coordinate: lastTrackingPoint))
        mapHolderView.moveCamera(cameraUpdate)
    }
    
    // MARK: - Button actions
    @objc private func buttonStartUpdatingLocationTap(sender : UIButton) {
        configureRoutePath()
        locationService.startLocation()
    }
    
    @objc private func buttonStopUpdatingLocationTap(sender : UIButton) {
        locationService.stopLocation()
        pushToRealm()
    }
    
    @objc private func buttonShowPreviousRouteTap(sender : UIButton) {
        locationService.isActiveLocation ? showTrakingStillActive() : showPreviousRoute()
    }
    
    @objc private func buttonChangeAvatarTap(sender : UIButton) {
        coordinator?.goToScene(with: .avatar)
    }
}

extension MapViewController {
    //Загрузка данных в БД Realm
    fileprivate func pushToRealm() {
        guard !trackLocations.isEmpty,
              trackLocations.count > 1 else { return }
        //Преобразование в Realm модель
        let trackLocationsRealm = RealmPath(trackLocations)
        //Загрузка
        do {
            let saveToDB = try realmService.update(trackLocationsRealm)
            cleanTrackLocations()
            print(saveToDB.configuration.fileURL?.absoluteString ?? "No avaliable file DB")
        } catch (let error) {
            showError(message: error.localizedDescription)
        }
    }
    
    //Получение данных из БД
    fileprivate func pullFromRealm() {
        do {
            let lastRealmPath = try realmService.get(RealmPath.self).last
            let lastRealmPathPoints = lastRealmPath?.trackLocations
                .toArray()
                .compactMap({ CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) })
            trackLocations = lastRealmPathPoints ?? []
        } catch (let error) {
            showError(message: error.localizedDescription)
        }
    }
}
