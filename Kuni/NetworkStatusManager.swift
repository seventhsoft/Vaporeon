//
//  NetworkStatusManager.swift
//  Kuni
//
//  Created by Daniel Martinez Segundo on 2/10/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit
import Alamofire
import GSMessages

enum ReachabilityManagerError: Error {
    case notReachable
}

class NetworkStatusManager {
    static let sharedInstance = NetworkStatusManager()
    
    private init() {}
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    /// key to send notification by changing the status of the network
    let listenerStatus = NSNotification.Name(rawValue:"NSNotificationKeyListenerNetworkStatusChanged")
    
    
    func startNetworkReachabilityObserver() {
        reachabilityManager?.listener = { status in
            let win = UIApplication.shared.keyWindow!
            switch status {
            case .notReachable, .unknown:
                win.showMessage("Sin conexión a Internet", type: .error , options: [
                    .animation(.slide),
                    .animationDuration(0.3),
                    .autoHide(false),
                    .autoHideDelay(3.0),
                    .height(60.0),
                    .hideOnTap(false),
                    .position(.top),
                    .textAlignment(.center),
                    .textColor(.white),
                    .textNumberOfLines(1),
                    .textPadding(40.0)
                    ])

            case .reachable(.ethernetOrWiFi), .reachable(.wwan):
                win.hideMessage()
            }
            
            NotificationCenter.default.post(name: self.listenerStatus,
                                            object: nil,
                                            userInfo: ["NetworkStatus": status])
            
        }
        reachabilityManager?.startListening()
    }
    
    func stopNetworkReachabilityObserver(){
        reachabilityManager?.stopListening()
        NotificationCenter.default.removeObserver(self.listenerStatus)
    }
    
    //MARK:-
    //MARK: check network
    
    /// check internet connection
    ///
    /// - returns: network status
    func checkInternetConnection() -> Bool {
        return (reachabilityManager?.isReachable)!
    }
}
