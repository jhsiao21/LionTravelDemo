//
//  MainTabBarViewController.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/4.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
                
        let HomeVC = UINavigationController(rootViewController: HomeViewController())
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        let SettingVC = UINavigationController(rootViewController: SettingViewController())
        
        HomeVC.tabBarItem.title = "Home"
        HomeVC.tabBarItem.image = UIImage(systemName: "house")
        
        SettingVC.tabBarItem.title = "Setting"
        SettingVC.tabBarItem.image = UIImage(systemName: "person")
        
        tabBar.tintColor = .systemPink
        tabBar.isTranslucent = false
        tabBar.shadowImage = UIImage()
        setViewControllers([HomeVC, SettingVC], animated: true)
    }
}
