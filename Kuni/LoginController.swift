//
//  LoginController.swift
//  Kuni
//
//  Created by Daniel on 26/07/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON


protocol LoginControllerDelegate: class {
    func finishLoggingIn()
}

class LoginController: UIViewController, UITextFieldDelegate, LoginControllerDelegate {
    var dict : [String : AnyObject]!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginFBButton: UIButton!
    
    var fbButtonAnchor: NSLayoutConstraint?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Transparent Navigation Bar
        let navBar = self.navigationController?.navigationBar
        navBar?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar?.shadowImage = UIImage()
        navBar?.isTranslucent = true
        
        password.delegate = self     
    }
    
    
    @IBAction func loginWithEmail(_ sender: UIButton) {
        // Validate fields in login form
        if self.validateFields() {
                //Login with email
                print("Login with email")
                let params: Parameters = [
                    "username": email.text!,
                    "client_id": "mobileClient",
                    "password" : password.text!,
                    "grant_type" : "password"
                ]
        
                let request = Alamofire.request(KuniRouter.loginUser(parameters: params))
                    .validate()
                    .responseJSON { response in
        
                        Debug.printDebugInfo(response: response)
                        
                        switch response.result {
                        case .success(let JSON):
                            print(JSON)
                            self.finishLoggingIn()
        
                        case .failure(let error):
                            let alert = Helpers.displayAlertMessage(title: "Error de acceso", messageToDisplay: "Ocurrió un error al iniciar sesión, por favor revise que sus datos sean correctos.")
                            self.present(alert, animated: true, completion:nil)
                            
                            if let data = response.data {
                                let json = String(data: data, encoding: String.Encoding.utf8)
                                print("Failure Response: \(JSON(json!))")
                            }
                            debugPrint(error)
                        }
                }
                debugPrint(request)
        }
        
    }
    
    
    @IBAction func loginWithFacebook(_ sender: UIButton) {
        //1.
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            
            //2.
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            //2.
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
//            //3.
//            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
//            
//            //4.
//            Auth.auth().signIn(with: credential, completion: { (user, error) in
//                
//                //5.
//                if let error = error {
//                    print("Login error: \(error.localizedDescription)")
//                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
//                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alertController.addAction(okayAction)
//                    self.present(alertController, animated: true, completion: nil)
//                    
//                    return
//                }
//                
//                //6.
//                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeController") {
//                    self.getFBUserData()
//                    UIApplication.shared.keyWindow?.rootViewController = viewController
//                    self.dismiss(animated: true, completion: nil)
//                }
//                
//            })
            
        }
    }


    
    @IBAction func showContestRules(_ sender: UIButton) {
        //Using a view controller
        let vc = TermsAndConditionsController();
        vc.modalTransitionStyle = .coverVertical
        present(vc, animated: true, completion: nil)
    }

    // Validate fields
    func validateFields() -> Bool {
        // Create and configure Form
        let formItems:[FormItem] = configureFormItems()
        let form:Form = Form()
        form.configureItems(formItemsParams: formItems)
        let formIsValid = form.isValid().0
        
        if !formIsValid {
            let alert = Helpers.displayAlertMessage(title: "Error de acceso", messageToDisplay: form.getLastMessage())
            self.present(alert, animated: true, completion:nil)
        }
        return formIsValid
    }
    
    
    // Delegate for UITetfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
            })
        }
    }
    
    func configureFormItems() -> [FormItem] {
        var formItems = [FormItem]()
        // eMail
        let emailItem = FormItem(message: "La dirección de correo no es válida, por favor revisela.")
        emailItem.value = email.text!
        emailItem.type = "email"
        
        // Password
        let passwordItem = FormItem(message: "La contraseña es demasiado corta, por favor revisela.")
        passwordItem.value = password.text!
        passwordItem.type = "password"
        
        formItems = [emailItem, passwordItem]
        return formItems
    
    }

    func sendToHome(){
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "HomeNavigation")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func finishLoggingIn() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingVC = storyboard.instantiateViewController(withIdentifier: "HomeNavigation") as! UINavigationController
        self.present(settingVC, animated: true, completion: {
            UIApplication.shared.keyWindow?.rootViewController = settingVC
            UserDefaults.standard.setIsLoggedIn(value: true)
        })
    }
    
    
}

