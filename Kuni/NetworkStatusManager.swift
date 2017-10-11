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
    private let view = UIView()
    
    private init() {}
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    /// key to send notification by changing the status of the network
    let listenerStatus = NSNotification.Name(rawValue:"NSNotificationKeyListenerNetworkStatusChanged")
    
    
    func startNetworkReachabilityObserver() {
        reachabilityManager?.listener = { status in

            switch status {
            case .notReachable, .unknown:
                print("Sin red")
                
            case .reachable(.ethernetOrWiFi), .reachable(.wwan):
                self.view.hideMessage()
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
