//
//  UIViewController+Extension.swift
//  SimpleReminder
//
//  Created by Ramchandra Nagalapelli on 23/06/21.
//

import UIKit

extension UIViewController {
    static func instantiate<VC: UIViewController>() -> VC {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let controller = storyboard.instantiateViewController(identifier: "\(self)") as? VC {
            return controller
        }
        fatalError("\(VC.self) not found in Main storyboard")
    }

    func showAlert(title: String?, message: String, action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            action?()
        }))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
