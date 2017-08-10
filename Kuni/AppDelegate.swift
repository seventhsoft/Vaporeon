//
//  AppDelegate.swift
//  Kuni
//
//  Created by Daniel on 11/07/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Llamamos al método application() que gestionará la llamada a la app de Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
       
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = MainNavigationController()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return handled
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
}

