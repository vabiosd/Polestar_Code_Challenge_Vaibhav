//
//  SceneDelegate.swift
//  OpenLibrary
//
//  Created by vaibhav singh on 16/12/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        ///   Assigning the window to SceneDelegate
        self.window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        
        /// Initialising the ContentListCoordinator and starting the app flow!
        let appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator.start()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }


}

