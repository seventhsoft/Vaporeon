//
//  NetworkStatusManager.swift
//  Kuni
//
//  Created by Daniel Martinez Segundo on 2/10/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import Foundation
import Alamofire

class NetworkStatusManager {
    static let sharedInstance = NetworkStatusManager()
    
    private init() {}
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    
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
        }
        reachabilityManager?.startListening()
    }
    
    func stopNetworkReachabilityObserver(){
        reachabilityManager?.stopListening()
    
    }
    
    
}
