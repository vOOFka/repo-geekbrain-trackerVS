//
//  NotificationsService.swift
//  trackerVS
//
//  Created by Home on 01.06.2022.
//

import Foundation
import UserNotifications

protocol NotificationsServiceProtocol {
    func isReminderNotificationsAllowed(completion: @escaping (Bool) -> ())
}

final class NotificationsService: NotificationsServiceProtocol {
    static public let shared = NotificationsService()
    
    private init() { }
    
    public func isReminderNotificationsAllowed(completion: @escaping (Bool) -> ()) {
        
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        })
    }
}
