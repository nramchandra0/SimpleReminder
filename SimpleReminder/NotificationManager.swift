//
//  NotificationManager.swift
//  SimpleReminder
//
//  Created by Ramchandra Nagalapelli on 24/06/21.
//

import UserNotifications

class NotificationManager {

    private let title = "Simple Reminder"
    static let shared = NotificationManager()

    func scheduleNotification(body: String, id: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { error in
            print(error?.localizedDescription ?? "")
        }
    }

    func cancelNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}
