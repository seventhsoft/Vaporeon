//
//  Session.swift
//  Kuni
//
//  Created by Daniel on 05/08/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import Foundation
import SwiftyJSON

class Session: NSObject {
    /// The shared instance of the KuniAuth.
    static let sharedInstance: Session = Session()
    
    private override init() {
        super.init()
        
    }
    
    func setValue(value: Any?, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    
    func getValue(key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
    func getValueAsString(value: String) -> String {
        if let access = getValue(key: value) {
            return "\(access)"
        }
        return ""
    }
    
    func addUsername(data: JSON, username: String) -> JSON {
        var json = data
        json["username"] = JSON(username)
        return json
    }
    
    func removeData(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "access_token")
        defaults.removeObject(forKey: "token_type")
        defaults.removeObject(forKey: "expires_in")
        defaults.removeObject(forKey: "refresh_token")
        defaults.removeObject(forKey: "scope")
        defaults.removeObject(forKey: "idUsuario")
        defaults.removeObject(forKey: "username")
        print("Data removed!")
        defaults.synchronize()
    }
    
    func setData(data: JSON) {
        let defaults = UserDefaults.standard
        if  let access_token = data["access_token"].string,
            let token_type = data["token_type"].string,
            let expires_in = data["expires_in"].int,
            let refresh_token = data["refresh_token"].string,
            let scope = data["scope"].string,
            let idUsuario = data["idUsuario"].int,
            let username = data["username"].string {
            defaults.set(access_token, forKey: "access_token")
            defaults.set(token_type, forKey: "token_type")
            defaults.set(expires_in, forKey: "expires_in")
            defaults.set(refresh_token, forKey: "refresh_token")
            defaults.set(scope, forKey: "scope")
            defaults.set(idUsuario, forKey: "idUsuario")
            defaults.set(username, forKey: "username")
            
            defaults.synchronize()
        } else {
            return
        }
        
        print("\n")
        print(data)
        print("\n")
    }
    
}
