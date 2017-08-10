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
    }
    
    @IBAction func showMenu(_ sender: UIBarButtonItem) {
        print("Click menu");
        
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        print("Click exit")
        UserDefaults.standard.setIsLoggedIn(value: false)
        perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
    }

    func showLoginController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingVC = storyboard.instantiateViewController(withIdentifier: "LoginNavigation") as! UINavigationController
        self.present(settingVC, animated: true, completion: {
            UIApplication.shared.keyWindow?.rootViewController = settingVC
        })

    }
    
}
