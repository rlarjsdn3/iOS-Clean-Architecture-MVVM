//
//  SceneDelegate.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 11/18/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        AppAppearance.setupAppearance()
        let navigationController = UINavigationController()
        
        window?.rootViewController = navigationController
//        appFlowCoordinator = AppFlowCoordinator(
//            navigationController: navigationController,
//            appDIContainer: appDIContainer
//        )
//        appFlowCoordinator?.start()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }

}

