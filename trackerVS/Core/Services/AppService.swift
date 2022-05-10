//
//  AppServise.swift
//  shopVS
//
//  Created by Home on 27.03.2022.
//

import UIKit

enum SceneIdentifier: String {
    case auth = "AuthViewController"
    case map = "MapViewController"
}

class AppService {
    // MARK: - Methods
    
    func getScene(with identifier: SceneIdentifier) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: identifier.rawValue)
    }
    
    func showModalScene(viewController: UIViewController, with identifier: SceneIdentifier) {
        let modalViewController = getScene(with: identifier)
        modalViewController.modalPresentationStyle = .overCurrentContext
        viewController.present(modalViewController, animated: true, completion: nil)
    }
    
    func showBlurView(_ rootViewController: UIViewController) {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(origin: .zero, size: UIScreen.main.bounds.size)
        rootViewController.view.addSubview(blurEffectView)
    }
    
    func hideBlurView(_ rootViewController: UIViewController) {
        rootViewController.view.subviews.forEach { subview in
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
}
