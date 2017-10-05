//
//  ParamsManager.swift
//  Kuni
//
//  Created by Daniel Martinez Segundo on 3/10/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import Foundation
import Alamofire

enum ParamsManager {
    case loginEmail(email: String, passwd: String)
    case signUpEmail
    case loginFacebook(email: String)
    case signUpFacebook(user: FacebookUser)
    
    var params: Parameters {
        switch self {
        case .loginEmail(let email, let password):
            return getLoginEmail(email: email, password: password)
        case .signUpEmail:
            return getSignUpEmail()
        case .loginFacebook(let email):
            return getLoginFacebook(email: email)
        case .signUpFacebook(let user):
            return getSignUpFacebook(user: user)
        }
    }
    
    
    private func getLoginEmail(email: String, password: String) -> Parameters {
        let params: Parameters = [
            "username": email,
            "client_id": "mobileClient",
            "password" : password,
            "grant_type" : "password"
        ]
        return params
    }

    private func getSignUpEmail() -> Parameters {
        let params: Parameters = [:]
        
        
        return params
    }
    
    private func getLoginFacebook(email: String) -> Parameters {
        let params: Parameters = [
            "username": email,
            "client_id": "mobileClient",
            "password" : "",
            "grant_type" : "password"
        ]
        return params
    }
    
    private func getSignUpFacebook(user: FacebookUser) -> Parameters {
        let params: Parameters = [
            "nombre" : user.firstName,
            "apaterno": user.lastName,
            "correo": user.email,
            "usuario": user.email,
            "password" : "",
            "facebook" : true,
            "activo" : false,
            "idPerfil" : 2
        ]
        return params
    }
    
}
