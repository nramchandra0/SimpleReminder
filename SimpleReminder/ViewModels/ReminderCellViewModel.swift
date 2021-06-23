//
//  ReminderCellViewModel.swift
//  SimpleReminder
//
//  Created by Ramchandra Nagalapelli on 23/06/21.
//

import CoreData

struct ReminderCellViewModel {
    let reminder: Reminder

    init(reminder: Reminder) {
        self.reminder = reminder
    }

    var completed: Bool {
        reminder.completed
    }

    var message: String? {
        reminder.message
    }

    var dateString: String? {
        guard let eventDate = reminder.date else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: eventDate)
    }
}
