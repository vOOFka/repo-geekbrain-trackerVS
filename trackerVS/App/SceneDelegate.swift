//
//  SceneDelegate.swift
//  trackerVS
//
//  Created by Home on 24.04.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let appService = AppService()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
        
        let coordinator = AppCoordinator(navigationController: navigationController,
                                         appService: appService)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        
        coordinator.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene),
              let rootViewController = windowScene.keyWindow?.rootViewController
        else { return }
        appService.hideBlurView(rootViewController)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene),
              let rootViewController = windowScene.keyWindow?.rootViewController
        else { return }
        appService.showBlurView(rootViewController)
        appService.setNotification(startOffset: 15.0)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}
