//
//  AppCoordinator.swift
//  SimpleReminder
//
//  Created by Ramchandra Nagalapelli on 23/06/21.
//

import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get }
    func start()
}

final class AppCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let navigationController = UINavigationController()

        let remainderListCoordinator = ReminderListCoordinator(navigationController: navigationController)
        remainderListCoordinator.start()
        childCoordinators.append(remainderListCoordinator)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
