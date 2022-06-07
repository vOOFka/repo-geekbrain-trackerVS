//
//  NotificationsService.swift
//  trackerVS
//
//  Created by Home on 01.06.2022.
//

import Foundation
import UserNotifications

protocol NotificationsServiceProtocol {
    var notificationUserInfoIdentifierKey: String { get }
    var notificationRestorationIdentifierKey: String { get }
    
    func isReminderNotificationsAllowed(_ completion: @escaping (Bool) -> ())
    func setNotification(alertBody: String, restorationIdentifier: String, startOffset: TimeInterval, _ completion: @escaping (Bool) -> ())
}

final class NotificationsService: NotificationsServiceProtocol {
    let notificationUserInfoIdentifierKey = "NotificationUserInfoIdentifierKey"
    let notificationRestorationIdentifierKey = "NotificationRestorationIdentifierKey"
    
    static public let shared = NotificationsService()
    
    private init() { }
    
    public func isReminderNotificationsAllowed(_ completion: @escaping (Bool) -> ()) {
        
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        })
    }
    
    public func setNotification(alertBody: String,
                                restorationIdentifier: String = "",
                                startOffset: TimeInterval = 0.0,
                                _ completion: @escaping (Bool) -> ()) {
        
        let reminderDate: Date = Date()
        let fireDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                 from: reminderDate.addingTimeInterval(startOffset))
        let content = UNMutableNotificationContent()
        
        content.body = alertBody
        content.userInfo = [notificationUserInfoIdentifierKey: alertBody,
                            notificationRestorationIdentifierKey: restorationIdentifier]
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDateComponents, repeats: false)
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        if let stringDateComponents = formatter.string(from: fireDateComponents) {
            let request = UNNotificationRequest(identifier: notificationUserInfoIdentifierKey + alertBody + stringDateComponents,
                                                content: content,
                                                trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                error == nil ? completion(true) : completion(false)
            })
        }
    }
}
