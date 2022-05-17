//
//  Date+Ext.swift
//  trackerVS
//
//  Created by Home on 03.05.2022.
//

import Foundation

extension Date {
    public var removeTimeStamp : Date? {
       guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
        return nil
       }
       return date
   }
}
