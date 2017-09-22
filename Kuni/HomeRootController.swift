//
//  HomeRootController.swift
//  Kuni
//
//  Created by Daniel on 14/08/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit
import Alamofire

class HomeRootController: DLHamburguerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Session Manager
        let baseURLString = KuniRouter.baseURLString
        let access = Session.sharedInstance.getValueAsString(value: "access_token")
        let refresh = Session.sharedInstance.getValueAsString(value: "refresh_token")
        
        let oauthHandler = OAuth2Handler(
            clientID: "mobileClient",
            baseURLString: baseURLString,
            accessToken: access,
            refreshToken: refresh
        )
        
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.adapter = oauthHandler
        sessionManager.retrier = oauthHandler
        print("Sesion manager: ")
        print("Access:  \(access)")
        print("Refresh: \(refresh)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        self.contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeNavigationController")
        self.menuViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeMenuController")
    }
}
