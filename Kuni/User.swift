//
//  User.swift
//  Kuni
//
//  Created by Daniel on 27/07/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import Foundation

struct User {
    var id: Int?
    var username: String?
    var email: String?
    var name: String?
    var last_name: String?
    var access_token: String?
    var refresh_token: String?
    var expires_in: Int?
}

class UserManager: NSObject {
    static let sharedInstance: UserManager = UserManager()
    
    var current: User?
    
    private override init(){
        super.init()
        

    }
    
    
}
