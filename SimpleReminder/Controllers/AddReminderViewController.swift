//
//  AddReminderViewController.swift
//  SimpleReminder
//
//  Created by Ramchandra Nagalapelli on 23/06/21.
//

import UIKit

class AddReminderViewController: UIViewController {

    // MARK: - Properties
    var viewModel: AddReminderViewModel!
    private let datePickerView = UIDatePicker()
    private let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
    lazy var doneButton: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didSelectDate))
    }()

    // MARK: - Outlets
    @IBOutlet private weak var dateTextField: UITextField!
    @IBOutlet private weak var messageTextField: UITextField!

    // MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        viewModel.onUpdate = reloadData()
        viewModel.showAlert = showAlert()
        viewModel.viewDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        viewModel.viewDidDisappear()
    }

    // MARK: - View Configuration Methods
    private func setupView() {
        navigationItem.title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black

        messageTextField.delegate = self

        datePickerView.preferredDatePickerStyle = .wheels
        datePickerView.datePickerMode = .dateAndTime
        datePickerView.minimumDate = Date().addingTimeInterval(60)
        dateTextField.inputView = datePickerView
        dateTextField.inputView?.backgroundColor = .white

        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, doneButton], animated: false)
        dateTextField.inputAccessoryView = toolbar
    }

    private func reloadData() -> () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            self.dateTextField.text = self.viewModel.dateString
            self.messageTextField.text = self.viewModel.message
        }
    }

    private func showAlert() -> (String) -> Void {
        return { [weak self] message in
            guard let self = self else { return }
            self.showAlert(title: "", message: message)
        }
    }

    // MARK: - Action Methods
    @IBAction private func addReminderButtonClicked() {
        view.endEditing(true)
        viewModel.addReminderButtonTapped()
    }

    @objc private func didSelectDate() {
        viewModel.didSelectDate(date: datePickerView.date)
        dateTextField.resignFirstResponder()
    }
}

extension AddReminderViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.didMessageChanged(message: textField.text ?? "")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
