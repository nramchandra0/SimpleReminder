//
//  CoreDataManager.swift
//  SimpleReminder
//
//  Created by Ramchandra Nagalapelli on 23/06/21.
//

import CoreData

final class CoreDataManager {

    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "SimpleReminder")
        persistentContainer.loadPersistentStores { (_, error) in
            print(error?.localizedDescription ?? "")
        }
        return persistentContainer
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func getAll<Object: NSManagedObject>() -> [Object] {
        do {
            let fetchRequest = NSFetchRequest<Object>(entityName: "\(Object.self)")
            return try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    func delete<Object: NSManagedObject>(object: Object) {
        context.delete(object)
        saveContext()
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    @discardableResult
    func addReminder(message: String, date: Date) -> Reminder {
        let reminder = Reminder(context: context)
        reminder.setValue(message, forKey: "message")
        reminder.setValue(date, forKey: "date")
        reminder.setValue(UUID(), forKey: "id")
        reminder.setValue(false, forKey: "completed")

        saveContext()
        return reminder
    }

    func updateReminder(_ reminder: Reminder, message: String, date: Date, completed: Bool) {
        reminder.setValue(message, forKey: "message")
        reminder.setValue(date, forKey: "date")
        reminder.setValue(completed, forKey: "completed")

        saveContext()
    }
}
