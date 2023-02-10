// ViewController+Extension.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import UIKit

/// Flexible alert
extension UIViewController {
    // MARK: - Public methods

    func showAlert(
        title: String?,
        message: String?,
        actionTitle: String?,
        handler: ((UIAlertAction) -> ())?
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let alertControllerAction = UIAlertAction(
            title: actionTitle,
            style: .default,
            handler: handler
        )
        alertController.addAction(alertControllerAction)
        present(alertController, animated: true)
    }

    func showApiKeyAlert(title: String?, message: String?, actionTitle: String, handler: ((String) -> Void)?) {
        let actionController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(
            title: actionTitle,
            style: .default
        ) { _ in
            guard let key = actionController.textFields?.first?.text else { return }
            handler?(key)
        }
        actionController.addTextField(configurationHandler: nil)
        actionController.addAction(alertAction)
        present(actionController, animated: true, completion: nil)
    }
}
