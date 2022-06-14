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
    case avatar = "AvatarViewController"
    case unknow
    
    static func sceneIdentifierFromString(identifier: String?) -> SceneIdentifier {
        switch identifier {
        case SceneIdentifier.auth.rawValue:
            return .auth
        case SceneIdentifier.map.rawValue:
            return .map
        default:
            return .unknow
        }
    }
}

class AppService {
    // MARK: - Methods
    let userDataCaretaker = UserDataCaretaker()
    
    func saveUserData(_ userData: UserData) {
        userDataCaretaker.save(userData: userData)
    }
    
    func getUserAvatar() -> UIImage? {
        guard let imageData = userDataCaretaker.retrieveUserData()?.avatarImage else {
            return nil
        }
        
       return UIImage(data: imageData)
    }
    
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
    
    func setNotification(_ alertBody: String = "", _ restorationIdentifier: String = "", startOffset: TimeInterval = 0.0) {
        NotificationsService.shared.isReminderNotificationsAllowed { isAllowed in
            if isAllowed {
                let alertBody = (alertBody.isEmpty) ? "Please come back, we will forgive everything!" : alertBody
                
                NotificationsService.shared.setNotification(alertBody: alertBody,
                                                            restorationIdentifier: restorationIdentifier,
                                                            startOffset: startOffset) { isSet in
                    print("Notification - \(isSet)")
                }
            }
        }
    }
    
}
