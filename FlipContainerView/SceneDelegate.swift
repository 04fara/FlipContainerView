//
//  SceneDelegate.swift
//  FlipContainerView
//
//  Created by Farid Kopzhassarov on 21/01/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = .init()
        window?.windowScene = scene
        window?.rootViewController = ExampleVC()
        window?.makeKeyAndVisible()
    }
}
