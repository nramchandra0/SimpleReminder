//
//  ReminderTableViewCell.swift
//  SimpleReminder
//
//  Created by Ramchandra Nagalapelli on 23/06/21.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {

    // MARK: - Properties
    private var completed: Bool = false {
        didSet {
            let image = UIImage(systemName: completed ? "checkmark.square.fill" : "square")
            checkBox.setImage(image, for: [])
            checkBox.tintColor = completed ? .systemBlue : .gray
        }
    }
    private var viewModel: ReminderCellViewModel?
    var onToggleCheckbox: (ReminderCellViewModel) -> Void = { _ in }

    // MARK: - Outlets
    @IBOutlet private weak var checkBox: UIButton!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    // MARK: - Action Methods
    @IBAction private func didToggleCheckBox() {
        completed.toggle()
        if let viewModel = viewModel {
            onToggleCheckbox(viewModel)
        }
    }

    // MARK: - Helper Methods
    func updateWith(viewModel: ReminderCellViewModel) {
        self.viewModel = viewModel
        completed = viewModel.completed
        messageLabel.text = viewModel.message
        dateLabel.text = viewModel.dateString
    }
}
