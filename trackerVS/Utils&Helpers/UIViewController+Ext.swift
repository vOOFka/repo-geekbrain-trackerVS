//
//  UIViewController+Ext.swift
//  shopVS
//
//  Created by Home on 27.03.2022.
//

import UIKit

extension UIViewController {
    func showError(message: String, title: String? = "Error", handler: ((UIAlertAction) -> Void)? = nil) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .default, handler: handler)
        
     //   Logger.shared.logEvent(message, param: ["showErrorTitle" : title ?? ""])
        
        alertViewController.addAction(closeAction)
        present(alertViewController, animated: true)
    }
}
