//
//  AppDelegate.swift
//  ForecastApp
//
//  Created by Luis Costa on 11/02/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = AppCoordinator.shared.buildForecastViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

