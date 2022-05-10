//
//  AppCoordinator.swift
//  trackerVS
//
//  Created by Home on 10.05.2022.
//

import UIKit

class AppCoordinator: Coordinator {
    var appService: AppService?
    var parentCoordinator: Coordinator?
    var childrens: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, appService: AppService) {
        self.navigationController = navigationController
        self.appService = appService
    }
    
    func start() {
        goToScene(with: .auth)
    }
    
    func goToScene(with identifier: SceneIdentifier) {
        guard var viewController = appService?.getScene(with: identifier) as? UIViewController & Coordinating
        else {
            let vc = UIViewController()
            navigationController.pushViewController(vc, animated: true)
            vc.showError(message: "Unknow error, please try again later.")
            return
        }
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}
