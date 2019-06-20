//
//  AppDelegate.swift
//  weather
//
//  Created by Vladimir Psyukalov on 19.06.2019.
//  Copyright © 2019 Vladimir Psyukalov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        window?.backgroundColor = UIColor.white
        let mapsNavigationController = navigationControllerWithRoot(viewControllers: [MapViewController()])
        let citiesNavigationController = navigationControllerWithRoot(viewControllers: [CitiesTableViewController()])
        let tabBarController = tabBarControllerWithRoot(viewControllers: [mapsNavigationController, citiesNavigationController])
        mapsNavigationController.tabBarItem = tabBarItem(key: "map")
        citiesNavigationController.tabBarItem = tabBarItem(key: "cities")
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }
    
    func navigationControllerWithRoot(viewControllers: [UIViewController]) -> UINavigationController {
        let navigationController = UINavigationController()
        let navigationBar = navigationController.navigationBar
        navigationController.viewControllers = viewControllers
        navigationBar.isTranslucent = false
        navigationBar.tintColor = UIColor.black
        navigationBar.barTintColor = UIColor.white
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        return navigationController
    }
    
    func tabBarControllerWithRoot(viewControllers: [UIViewController]) -> UITabBarController {
        let tabBarController = UITabBarController()
        let tabBar = tabBarController.tabBar
        tabBarController.delegate = self as? UITabBarControllerDelegate
        tabBarController.viewControllers = viewControllers
        tabBar.isTranslucent = false
        tabBar.tintColor = UIColor.init(red: 32.0 / 255.0, green: 168.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
        tabBar.barTintColor = UIColor.white
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        return tabBarController
    }
    
    func tabBarItem(key: String) -> UITabBarItem {
        let image = UIImage.init(named: "tab_bar_item_default_" + key)
        let selectedImage = UIImage.init(named: "tab_bar_item_selected_" + key)
        let tabBarItem = UITabBarItem.init(title: "", image: image, selectedImage: selectedImage)
        tabBarItem.imageInsets = UIEdgeInsets.init(top: 8.0, left: 0.0, bottom: -8.0, right: 0.0)
        return tabBarItem
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }

}
