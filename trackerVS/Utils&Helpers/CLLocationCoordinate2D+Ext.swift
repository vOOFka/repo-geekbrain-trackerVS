//
//  CLLocationCoordinate2D+Ext.swift
//  trackerVS
//
//  Created by Home on 03.05.2022.
//

import GoogleMaps

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}
