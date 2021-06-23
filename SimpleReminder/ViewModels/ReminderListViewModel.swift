//
//  ReminderListViewModel.swift
//  SimpleReminder
//
//  Created by Ramchandra Nagalapelli on 23/06/21.
//

import Foundation

class ReminderListViewModel {

    let title = "Reminders"
    let deleteActionTitle = "Delete"
    let notificationTitle = "Simple Reminder"
    let noDataMessage = "No Reminders yet. Add new Reminders by clicking \"Plus\" icon on the top."
    var onUpdate: () -> Void = {}

    weak var coordinator: ReminderListCoordinator?
    private lazy var coreData: CoreDataManager = {
        CoreDataManager()
    }()
    private var reminderCellViewModels: [ReminderCellViewModel] = []

    func viewDidLoad() {
        reloadData()
    }

    func reloadData() {
        let reminders: [Reminder] = CoreDataManager.shared.getAll()
        reminderCellViewModels = reminders.map({ ReminderCellViewModel(reminder: $0) })
        onUpdate()
    }

    func numberOfRows() -> Int {
        reminderCellViewModels.count
    }

    func reminderViewModel(for indexPath: IndexPath) -> ReminderCellViewModel {
        return reminderCellViewModels[indexPath.row]
    }

    func deleteReminder(at indexPath: IndexPath) {
        let reminder = reminderViewModel(for: indexPath).reminder
        cancelNotification(for: reminder)
        CoreDataManager.shared.delete(object: reminder)
        reminderCellViewModels.remove(at: indexPath.row)
        onUpdate()
    }

    func addReminderButtontapped() {
        coordinator?.presentAddReminderScreen()
    }

    func onToggleCheckBox() -> (ReminderCellViewModel) -> Void {
        return { [weak self] cellViewModel in
            let reminder = cellViewModel.reminder
            CoreDataManager.shared.updateReminder(reminder, message: reminder.message!, date: reminder.date!, completed: !reminder.completed)
            if reminder.completed {
                self?.scheduleNotification(for: reminder)
            } else {
                self?.cancelNotification(for: reminder)
            }
            self?.reloadData()
        }
    }

    private func scheduleNotification(for reminder: Reminder) {
        if let message = reminder.message,
           let date = reminder.date,
           let id = reminder.id?.uuidString {
            NotificationManager.shared.scheduleNotification(body: message, id: id, date: date)
        }
    }

    private func cancelNotification(for reminder: Reminder) {
        if let id = reminder.id?.uuidString {
            NotificationManager.shared.cancelNotification(id: id)
        }
    }
}
