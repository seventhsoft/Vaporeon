//
//  NetworkStatusManager.swift
//  Kuni
//
//  Created by Daniel Martinez Segundo on 2/10/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import Foundation
import Alamofire

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
            switch status {
                
            case .notReachable:
                print("The network is not reachable")
                
            case .unknown :
                print("It is unknown whether the network is reachable")
                
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
                
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
                
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
    
//    /// check internet connection (throws)
//    ///
//    /// - throws: in the absence of network
//    func checkConnection() throws {
//        switch reachabilityManager?.networkReachabilityStatus {
//        case NetworkReachabilityManager.NetworkReachabilityStatus.notReachable,
//             NetworkReachabilityManager.NetworkReachabilityStatus.unknown:
//            throw ReachabilityManagerError.notReachable
//        default: return
//        }
//    }
    
    
}
