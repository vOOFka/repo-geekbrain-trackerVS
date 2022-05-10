//
//  Coordinator.swift
//  trackerVS
//
//  Created by Home on 10.05.2022.
//

import UIKit

protocol Coordinator {
    var appService: AppService? { get }
    var parentCoordinator: Coordinator? { get set }
    var childrens: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
    func goToScene(with identifier: SceneIdentifier)
}

protocol Coordinating {
    var coordinator: Coordinator? { get set }
}
