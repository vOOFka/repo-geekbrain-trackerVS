//
//  RealmPath.swift
//  trackerVS
//
//  Created by Home on 03.05.2022.
//

import Foundation
import RealmSwift
import GoogleMaps

final class RealmPath: Object {
    @Persisted (primaryKey: true) var pathID: String = UUID.init().uuidString
    @Persisted var date: Date
    @Persisted var trackLocations = List<RealmPathPoints>()


    convenience init(_ trackLocations: [CLLocationCoordinate2D]) {
        self.init()
        self.date = Date()
        self.trackLocations = {
            let pointsList = List<RealmPathPoints>()
            for point in trackLocations {
                let pointObj = RealmPathPoints.init(point)
                pointsList.append(pointObj)
            }
            return pointsList
        }()
    }
}

final class RealmPathPoints: Object {
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    
    convenience init(_ pointLocation: CLLocationCoordinate2D) {
        self.init()
        self.latitude = pointLocation.latitude
        self.longitude = pointLocation.longitude
    }
}
