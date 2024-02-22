//
//  SceneDelegate.swift
//  HumanProxy
//
//  Created by Fernando Cani on 19/02/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        let service: ServiceType = .live

        let vc = MainViewController(viewModel: MainViewModel(service: service))
        self.window?.rootViewController = self.createNavigationController(viewController: vc)
        
        self.window?.makeKeyAndVisible()
    }
    
    private func createNavigationController(viewController: UIViewController) -> UINavigationController {
        let nc = UINavigationController(rootViewController: viewController)
        nc.navigationBar.prefersLargeTitles = true
        return nc
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }

}
