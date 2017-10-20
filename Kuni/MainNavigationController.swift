//
//  MainNavigationController.swift
//  Kuni
//
//  Created by Daniel on 05/08/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//


import UIKit
import FBSDKLoginKit
import Alamofire

class MainNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if isLoggedIn() {
            perform(#selector(showHomeController), with: nil, afterDelay: 0.01)
        } else {
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
        }
    }
    
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.isLoggedIn()
    }

    fileprivate func hasSeenOnboarding() -> Bool {
        return UserDefaults.standard.hasSeenOnboarding()
    }
    
    func showHomeController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingVC = storyboard.instantiateViewController(withIdentifier: "HomeRootController")
        self.present(settingVC, animated: true, completion: {
            UIApplication.shared.keyWindow?.rootViewController = settingVC
        })
        
    }
    
    func showLoginController() {
        let homeVC = hasSeenOnboarding() ? "LoginNavigation" : "OnboardingNavigation"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingVC = storyboard.instantiateViewController(withIdentifier: homeVC) as! UINavigationController
        self.present(settingVC, animated: true, completion: {
            UIApplication.shared.keyWindow?.rootViewController = settingVC
        })

    }
}
