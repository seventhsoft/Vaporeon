//
//  User.swift
//  Kuni
//
//  Created by Daniel on 27/07/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import Foundation
import SwiftyJSON

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

class Profile {
    var id: Int
    var username: String
    var email: String
    var name: String
    var last_name: String
    
    init(dictionary: JSON) {
        self.id = dictionary["idUsuario"].intValue
        self.username = dictionary["usuario"].stringValue
        self.email = dictionary["persona"]["correo"].stringValue
        self.name = dictionary["persona"]["nombre"].stringValue
        self.last_name = dictionary["persona"]["apaterno"].stringValue
        
    }
}
