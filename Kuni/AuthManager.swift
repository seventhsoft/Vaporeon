//
//  KuniAuth.swift
//  Kuni
//
//  Created by Daniel on 11/08/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/**
 *  Structure that holds the properties on the current user.
 */
struct KuniUser {
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var pictureURL: String = ""
}

class AuthManager: NSObject {
    // MARK: - Constants
    
    /// The shared instance of the KuniAuth.
    static let sharedInstance: AuthManager = AuthManager()
    private let defaultManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
    
    // MARK: - Initializers
    
    private override init() {
        super.init()

    }
    
    func login( params: Parameters, ref: LoginController) {
        let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        let request = sessionManager.request(KuniRouter.loginUser(parameters: params))
            .validate()
            .responseJSON { response in
                let _ = sessionManager // retain
                Debug.printDebugInfo(response: response)
                switch response.result {
                case .success(let data):
                    var json = JSON(data)
                    let session = Session.sharedInstance
                    json = session.addUsername(data: json, username: params["username"] as! String)
                    session.setData(data: json)
                    ref.finishLoggingIn()
                    if let access = session.getValue(key: "access_token") {
                        print(access)
                    }
                    
                case .failure(let error):
                    let alert = Helpers.displayAlertMessage(title: "Error de acceso", messageToDisplay: "Ocurrió un error al iniciar sesión, por favor revise que sus datos sean correctos.")
                    ref.present(alert, animated: true, completion:nil)
                    
                    if let data = response.data {
                        let json = String(data: data, encoding: String.Encoding.utf8)
                        print("Failure Response: \(JSON(json!))")
                    }
                    debugPrint(error)
                }
        }
        debugPrint(request)
    }
    
    
    func signUp( params: Parameters, ref: UIViewController){
        let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        let request = sessionManager.request(KuniRouter.registerUser(parameters: params))
            .validate()
            .responseData { response in
                let _ = sessionManager // retain
                switch response.result {
                case .success(let JSON):
                    print(JSON)
                    let alert = Helpers.displayAlertMessage(title: "¡Casi estás listo!", messageToDisplay: "Revisa tu correo electrónico y haz clic en el enlace que te aparece para confirmar tu cuenta")
                    ref.present(alert, animated: true, completion:nil)
                case .failure:
                    if let object = response.response {
                        if(object.statusCode == 412 || object.statusCode == 409){
                            let alert = Helpers.displayAlertMessage(title: "Error de registro", messageToDisplay: "El correo que intentas registrar ya existe, por favor revisalo.")
                            ref.present(alert, animated: true, completion:nil)
                        }
                    }
//                    if let data = response.data {
//                        let json = String(data: data, encoding: String.Encoding.utf8)
//                        print("Failure Response: \(JSON(json!))")
//                    }
                }
        }
        debugPrint(request)
    }
    
    func signUpFB(){
    
    }
    
    func lostPassword( params: Parameters, ref: UIViewController){
        let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        sessionManager.request(KuniRouter.lostPassword(parameters: params))
            .validate()
            .responseString { response in
                let _ = sessionManager // retain
                Debug.printDebugInfo(response: response)
                switch response.result {
                case .success:
                    let alert = Helpers.displayAlertMessage(title: "Te enviamos un correo", messageToDisplay: "Revisa tu correo electrónico y haz clic en el enlace que te aparece para restablecer tu contraseña")
                    ref.present(alert, animated: true, completion:nil)
                    
                case .failure(let error):
                    if let data = response.data {
                        let json = String(data: data, encoding: String.Encoding.utf8)
                        print("Failure Response: \(json!)")
                    }
                    debugPrint(error)
                }
        }
    }
    
    func logout(){
        revokeToken()
        revokeRefreshToken()
        Session.sharedInstance.removeData()
        print("Closing session, removing data")
    }
    
    private func revokeToken(){
        let access = Session.sharedInstance.getValueAsString(value: "access_token")
        let params: Parameters = [ "token": access ]
        
        defaultManager.request(KuniRouter.refreshToken(parameters: params))
            .validate()
            .responseString { response in
                print("Revoque token.")
                switch response.result {
                case .success:
                    print("Revoque token done.")
                    break
                case .failure(let error):
                    if let data = response.data {
                        let json = String(data: data, encoding: String.Encoding.utf8)
                        print("Failure Response: \(json!)")
                    }
                    debugPrint(error)
                }
        }
    }
    
    private func revokeRefreshToken(){
        let refresh = Session.sharedInstance.getValueAsString(value: "refresh_token")
        let params: Parameters = [ "token": refresh ]
        
        defaultManager.request(KuniRouter.refreshToken(parameters: params))
            .validate()
            .responseString { response in
                print("Refresh token.")
                switch response.result {
                case .success:
                    print("Refresh token done.")
                    break
                case .failure(let error):
                    if let data = response.data {
                        let json = String(data: data, encoding: String.Encoding.utf8)
                        print("Failure Response: \(json!)")
                    }
                    debugPrint(error)
                }
        }
    }
    
    // Completion handler to getProfile
    func getProfile(completionHandler: @escaping (Profile, Error?) -> ()) {
        fetchProfile(completionHandler: completionHandler)
    }
    
    
    private func fetchProfile(completionHandler: @escaping (Profile, Error?) -> ()) {
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.request(KuniRouter.getProfile)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let profile = Profile(dictionary: JSON(data))
                    completionHandler(profile, nil)
                    break
                case .failure(let error):
                    if let data = response.data {                                                
                        let json = String(data: data, encoding: String.Encoding.utf8)
                        print("Failure Response: \(json!)")
                    }
                    debugPrint(error)
                }
        }
    }
    
    func setProfile(params: Parameters, completionHandler: @escaping (Bool, Error?) -> ()) {
        submitProfile(params: params, completionHandler: completionHandler)
    }
    
    private func submitProfile(params: Parameters, completionHandler: @escaping (Bool, Error?) -> ()) {
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.request(KuniRouter.setProfile(parameters: params))
            .validate()
            .responseData { response in
                switch response.result {
                case .success:
                    completionHandler(true, nil)
                    break
                case .failure(let error):
                    if let data = response.data {
                        let json = String(data: data, encoding: String.Encoding.utf8)
                        print("Failure Response: \(json!)")
                    }
                    debugPrint(error)
                    completionHandler(false, nil)
                }
        }
    }
    
    
}
