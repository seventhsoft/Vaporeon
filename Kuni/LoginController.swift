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
    var dict : [String : String] = [:]
    
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
        if validateFields() {
            //Login with email
            print("Login with email")
            let params: Parameters = [
                "username": email.text!,
                "client_id": "mobileClient",
                "password" : password.text!,
                "grant_type" : "password"
            ]
            
            let auth = AuthManager.sharedInstance
            auth.login(params: params, ref: self)
        }
    }
    
    
    @IBAction func loginWithFacebook(_ sender: UIButton) {
        let fbMngr = FacebookManager.sharedInstance
        fbMngr.handleUserAccess()
        print("--- LAST ACTIVITY ---")
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
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "HomeRootController")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func finishLoggingIn() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingVC = storyboard.instantiateViewController(withIdentifier: "HomeRootController") 
        self.present(settingVC, animated: true, completion: {
            UIApplication.shared.keyWindow?.rootViewController = settingVC
            UserDefaults.standard.setIsLoggedIn(value: true)
        })
    }
    
    
}

