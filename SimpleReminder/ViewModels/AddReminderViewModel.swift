//
//  AddReminderViewModel.swift
//  SimpleReminder
//
//  Created by Ramchandra Nagalapelli on 23/06/21.
//

import Foundation

class AddReminderViewModel {

    let title = "Add"
    private(set) var message: String = "" {
        didSet {
            onUpdate()
        }
    }
    private var date: Date = Date().addingTimeInterval(60) {
        didSet {
            onUpdate()
        }
    }
    var dateString: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mma"
        return dateFormatter.string(from: date)
    }
    var onUpdate: () -> Void = {}
    var showAlert: (String) -> Void = { _ in }

    weak var coordinator: AddReminderCoordinator?

    func viewDidLoad() {
        onUpdate()
    }

    func viewDidDisappear() {
        coordinator?.didFinish()
    }

    func addReminderButtonTapped() {
        guard validateData() else { return }

        let reminder = CoreDataManager.shared.addReminder(message: message, date: date)
        scheduleNotification(for: reminder)

        coordinator?.didFinishAddReminder()
    }

    private func validateData() -> Bool {
        if message.isEmpty {
            showAlert("Enter valid message...")
        }
        return !message.isEmpty
    }

    func didMessageChanged(message: String) {
        self.message = message.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func didSelectDate(date: Date) {
        self.date = date
    }

    private func scheduleNotification(for reminder: Reminder) {
        if let message = reminder.message,
           let date = reminder.date,
           let id = reminder.id?.uuidString {
            NotificationManager.shared.scheduleNotification(body: message, id: id, date: date)
        }
    }
}
