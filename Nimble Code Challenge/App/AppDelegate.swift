//
//  AppDelegate.swift
//  Nimble Code Challenge
//
//  Created by Thien Huynh on 3/26/22.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // enable IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        // clear token
        UserDefaultsManager.shared.clearToken()
        // setup window and first scene
        window = UIWindow(frame: UIScreen.main.bounds)
        navigateToLogin()
        window?.makeKeyAndVisible()
        
        return true
    }

    
    func navigateToHome() {
        if let homeNav = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "HomeNavigation") as? UINavigationController {
            window?.rootViewController = homeNav
        }
    }
    
    func navigateToLogin() {
        let loginVC = LoginVC.initFromStoryboard()
        window?.rootViewController = loginVC
    }
}

