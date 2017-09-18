//
//  HomeController.swift
//  Kuni
//
//  Created by Daniel on 05/08/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit
import SwiftIconFont

class HomeController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Transparent Navigation Bar
        let navBar = self.navigationController?.navigationBar
        navBar?.tintColor = .white
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navBar?.barTintColor = UIColor(rgb: 0x1F8689)
        navBar?.backgroundColor = UIColor(rgb: 0x1F8689)
        navBar?.shadowImage = UIImage()
        navBar?.isTranslucent = false
        
        self.tabBar.tintColor = UIColor(rgb: 0xCF368E)
        self.tabBar.backgroundColor = UIColor(rgb: 0xFFFFFF)
    
        let dashboardNav = setViewController(viewController: DashboardController(collectionViewLayout: UICollectionViewFlowLayout()), title: "KUNI", tabTitle: "Inicio", iconCode: "ios-home")
        let rewardsNav = setViewController(viewController: RewardsController(), title: "Premios", tabTitle: "Premios", iconCode: "trophy")
        let profileNav = setViewController(viewController: ProfileController(), title: "Perfil", tabTitle: "Perfil", iconCode: "person")
        viewControllers = [dashboardNav, rewardsNav, profileNav]
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor(rgb: 0xD0D0D0).cgColor
        
        tabBar.layer.addSublayer(topBorder)
        tabBar.isTranslucent = false
        tabBar.clipsToBounds = true
        
    }
    
    func setViewController(viewController: UIViewController, title: String, tabTitle: String, iconCode: String) -> UINavigationController {
        viewController.title = title
        viewController.tabBarItem.icon(from: .Ionicon, code: iconCode, imageSize: CGSize(width: 20, height: 20), ofSize: 20)
        viewController.tabBarItem.title = tabTitle
        let nav = UINavigationController(rootViewController: viewController)
        nav.navigationBar.tintColor = UIColor(rgb: 0xCF368E)
        nav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(rgb: 0xCF368E)]
        nav.navigationBar.barTintColor = UIColor(rgb: 0xFFFFFF)
        nav.navigationBar.backgroundColor = UIColor(rgb: 0xFFFFFF)
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.isTranslucent = false
        return nav
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showMenu(_ sender: UIBarButtonItem) {
        self.findHamburguerViewController()?.showMenuViewController()
        
    }    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
}
