//
//  ReminderListCoordinator.swift
//  SimpleReminder
//
//  Created by Ramchandra Nagalapelli on 23/06/21.
//

import UIKit

final class ReminderListCoordinator: Coordinator {

    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    var parent: AddReminderCoordinator?
    var onAddEvent: () -> Void = {}

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let controller: ReminderListViewController = .instantiate()
        let viewModel = ReminderListViewModel()
        controller.viewModel = viewModel
        viewModel.coordinator = self
        onAddEvent = viewModel.reloadData
        navigationController.setViewControllers([controller], animated: false)
    }

    func presentAddReminderScreen() {
        let coordinator = AddReminderCoordinator(navigationController: navigationController)
        coordinator.parent = self
        coordinator.start()
        childCoordinators.append(coordinator)
    }

    func childDidFinish(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
