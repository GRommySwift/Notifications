//
//  Notifications.swift
//  Notifications
//
//  Created by Roman Holovai on 10.10.2021.
//  Copyright © 2021 Alexey Efimov. All rights reserved.
//

import UIKit
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()

    func requesAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert,.sound,.badge]) { granted, error in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self.getNotificationsSettings()
        }
    }
    
    func getNotificationsSettings() {
        notificationCenter.getNotificationSettings { settings in
            print("nottifications settings: \(settings)")
        }
    }
    
    func scheduleNotification(notificationType: String) {
        let content = UNMutableNotificationContent()
        let userAction = "User Action"
        
        content.title = notificationType
        content.body = "This is example how to create" + notificationType
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userAction
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let identifier = "Local notification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: userAction,
                                              actions: [snoozeAction,deleteAction],
                                              intentIdentifiers: [],
                                              options: [])
        notificationCenter.setNotificationCategories([category])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notification with the local Notification Identifier")
        }
        
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Snooze":
            print("snooze")
            scheduleNotification(notificationType: "Reminder")
        case "Delete":
            print("Delete action")
        default:
            print("Uknown action")
        }
        completionHandler()
    }
    
}
