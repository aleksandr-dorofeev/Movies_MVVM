// SceneDelegate.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: ApplicationCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let assemblyModuleBuilder = AssemblyModuleBuilder()
        window.makeKeyAndVisible()
        self.window = window
        coordinator = ApplicationCoordinator(assemblyModuleBuilder: assemblyModuleBuilder)
        coordinator?.start()
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(url)
    }
}
