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
    
    func logout(){
        
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
    
    private func revokeToken(){
    
    }
    
    private func revokeRefreshToken(){
    
    }
    
    
    func getProfile(completionHandler: @escaping (NSDictionary?, Error?) -> ()) {
        fetchProfile(completionHandler: completionHandler)
    }
    
    
    func fetchProfile(completionHandler: @escaping (NSDictionary?, Error?) -> ()) {
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.request(KuniRouter.getProfile)
            .validate()
            .responseJSON { response in
//                print("REQUEST = \(response.request?.allHTTPHeaderFields)")
//                print("REQUEST = \(response.request?.httpBody)")
                switch response.result {
                case .success(let data):
                    completionHandler(data as? NSDictionary, nil)
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
    
    
}
