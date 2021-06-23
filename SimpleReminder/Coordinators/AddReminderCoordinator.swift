//
//  AddReminderCoordinator.swift
//  SimpleReminder
//
//  Created by Ramchandra Nagalapelli on 23/06/21.
//

import UIKit

final class AddReminderCoordinator: Coordinator {

    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private var modalNavigationController: UINavigationController?
    weak var parent: ReminderListCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = AddReminderViewModel()
        viewModel.coordinator = self
        let controller: AddReminderViewController = .instantiate()
        controller.viewModel = viewModel
        modalNavigationController = UINavigationController(rootViewController: controller)
        if let navController = modalNavigationController {
            navigationController.present(navController, animated: true, completion: nil)
        }
    }

    func didFinish() {
        parent?.childDidFinish(self)
    }

    func didFinishAddReminder() {
        parent?.onAddEvent()
        modalNavigationController?.dismiss(animated: true, completion: nil)
    }
}
