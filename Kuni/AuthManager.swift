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

    // Completion handler to login
    func login(params: Parameters, completionHandler: @escaping (Bool) -> ()) {
        doLogin(params: params, completionHandler: completionHandler)
    }
    
    private func doLogin(params: Parameters, completionHandler: @escaping (Bool) -> ()) {
        let request = defaultManager.request(KuniRouter.loginUser(parameters: params))
            .validate()
            .responseJSON { response in
                //Debug.printDebugInfo(response: response)
                switch response.result {
                case .success(let data):
                    var json = JSON(data)
                    let session = Session.sharedInstance
                    json = session.addUsername(data: json, username: params["username"] as! String)
                    session.setData(data: json)
                    completionHandler(true)
                case .failure(let error):
                    if let data = response.data {
                        let json = String(data: data, encoding: String.Encoding.utf8)
                        print("Failure Response: \(JSON(json!))")
                    }
                    print("Error Login")
                    debugPrint(error)
                    completionHandler(false)
                }
        }
        print("Request Login")
        debugPrint(request)
    }
    
    // Completion handler to login
    func signUp(params: Parameters, completionHandler: @escaping (Bool, Int) -> ()) {
        doSignUp(params: params, completionHandler: completionHandler)
    }
    
    func doSignUp( params: Parameters, completionHandler: @escaping (Bool, Int) -> ()) {
        let request = defaultManager.request(KuniRouter.registerUser(parameters: params))
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let JSON):
                    print(JSON)
                    completionHandler(true, 200)
                case .failure(let error):
                    if let data = response.data {
                        let json = String(data: data, encoding: String.Encoding.utf8)
                        print("Failure Response: \(json!)")
                    }
                    print("Error?")
                    debugPrint(error)
                    
                    if let object = response.response {
                        completionHandler(false, object.statusCode)
                    }
                    print("Response: ")
                    debugPrint(response)
                }
        }
        print("Request: ")
        debugPrint(request)
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
    }
    
    private func revokeToken(){
        let access = Session.sharedInstance.getValueAsString(value: "access_token")
        let params: Parameters = [ "token": access ]
        
        defaultManager.request(KuniRouter.refreshToken(parameters: params))
            .validate()
            .responseString { response in
                let _ = self.defaultManager // retain
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
                let _ = self.defaultManager // retain
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
