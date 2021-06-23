//
//  ReminderListViewController.swift
//  SimpleReminder
//
//  Created by Ramchandra Nagalapelli on 23/06/21.
//

import UIKit

class ReminderListViewController: UIViewController {

    // MARK: - Properties
    var viewModel: ReminderListViewModel!

    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var messageLabel: UILabel!

    // MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

        viewModel.onUpdate = { [weak self] in
            self?.reloadData()
        }
        viewModel.viewDidLoad()
    }

    // MARK: - View configuration methods
    private func setupView() {
        let plus = UIImage(systemName: "plus.circle.fill")
        let plusButton = UIBarButtonItem(image: plus, style: .plain, target: self, action: #selector(addReminder))
        navigationItem.title = viewModel.title
        navigationItem.rightBarButtonItem = plusButton
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        messageLabel.text = viewModel.noDataMessage
    }

    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.messageLabel.isHidden = self.viewModel.numberOfRows() > 0
        }
    }

    // MARK: - Action Methods
    @objc private func addReminder() {
        viewModel.addReminderButtontapped()
    }
}

extension ReminderListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderTableViewCell", for: indexPath) as! ReminderTableViewCell
        let cellViewModel = viewModel.reminderViewModel(for: indexPath)
        cell.updateWith(viewModel: cellViewModel)
        cell.onToggleCheckbox = viewModel.onToggleCheckBox()
        return cell
    }
}

extension ReminderListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: viewModel.deleteActionTitle) { [weak self] (_, _, _) in
            self?.viewModel.deleteReminder(at: indexPath)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
}
