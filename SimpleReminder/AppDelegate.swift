//
//  AppDelegate.swift
//  SimpleReminder
//
//  Created by Ramchandra Nagalapelli on 23/06/21.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
                let options: UNAuthorizationOptions = [.alert, .sound, .badge]
                notificationCenter.requestAuthorization(options: options) {
                    (didAllow, error) in
                    if !didAllow {
                        print("User has declined notifications")
                    }
                }
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notifications with the Local Notification Identifier")
        }
        completionHandler()
    }
}

