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
    
    func showTrakingStillActive(handler: ((UIAlertAction) -> Void)? = nil) {
        let message = "Tracking is still active, OK - cancel the current route and show the previous one, attention cancellation will lead to the loss of the current route."
        
        let alertViewController = UIAlertController(title: "Notification",
                                                    message: message,
                                                    preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            let mapViewController = self as? MapViewController
            mapViewController?.cancelCurrentTracking()
        })
        let closeAction = UIAlertAction(title: "Close", style: .default, handler: handler)
        
        alertViewController.addAction(okAction)
        alertViewController.addAction(closeAction)
        present(alertViewController, animated: true)
    }
}
