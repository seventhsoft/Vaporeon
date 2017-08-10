//
//  Session.swift
//  Kuni
//
//  Created by Daniel on 05/08/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import Foundation

class Session {
//    var access_token: String = "access_token"
//    var token_type: String = "token_type"
//    var refresh_token: String = "refresh_token"
//    var expires_in: Int = 0
//    var scope: String = "scope"
//    var username: String = "username"
//    var idUsuario:Int = 0
//    
    init(){}
    
    static func setValue(value: Any?, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    
    static func getValue(key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }

    static func setData(token_type:String, refresh_token: String, access_token: String, expires_in: Int, scope: String, username: String) {
        let defaults = UserDefaults.standard
        
        defaults.set(token_type, forKey: "token_type")
        defaults.set(refresh_token, forKey: "refresh_token")
        defaults.set(access_token, forKey: "access_token")
        defaults.set(expires_in, forKey: "expires_in")
        defaults.set(scope, forKey: "scope")
        defaults.set(username, forKey: "username")
        
        UserDefaults.standard.synchronize()
    }
    
}
