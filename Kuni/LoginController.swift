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

        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "LoginImage")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        password.delegate = self     
    }
    
    //Login with email
    @IBAction func loginWithEmail(_ sender: UIButton) {
        // Validate fields in login form
        if validateFields() {
            print("Login with email")
            let params = ParamsManager.loginEmail(email: email.text!, passwd: password.text!).params
            AuthManager.sharedInstance.login(params: params){ success in
                if(success){
                    self.finishLoggingIn()
                } else {
                    let alert = Helpers.displayAlertMessage(
                        title: "Error de acceso",
                        messageToDisplay: "Ocurrió un error al iniciar sesión, por favor revise que sus datos sean correctos."
                    )
                    self.present(alert, animated: true, completion:nil)
                }
                return
            }
        }
    }
    
    
    @IBAction func loginWithFacebook(_ sender: UIButton) {
        FacebookManager.sharedInstance.handleUserAccess(){ success in
            if(success) {
                if let user = FacebookManager.sharedInstance.getCurrentUser() {
                    let params = ParamsManager.loginFacebook(email: user.email).params
                    AuthManager.sharedInstance.login(params: params){ success in
                        if(success){
                            self.finishLoggingIn()
                        } else {
                            print("Comenzando registro FB")
                            self.signUpWithFacebook(user: user)
                        }
                        return
                    }
                }
            }
            return
        }
    }
    
    
    func signUpWithFacebook(user: FacebookUser) {
        let params = ParamsManager.signUpFacebook(user: user).params
        AuthManager.sharedInstance.signUp(params: params){ success, code in
            if(success){
                let params = ParamsManager.loginFacebook(email: user.email).params
                AuthManager.sharedInstance.login(params: params){ success in
                    if(success){
                        self.finishLoggingIn()
                    }
                    return
                }
            }
            return
        }
    }
    
    
    @IBAction func showContestRules(_ sender: UIButton) {
        //Using a view controller
        let vc = ContestAndPrivacyController()
        vc.url = "http://about.juegakuni.mx/bases.html"
        vc.dialogTitle = "Bases del concurso"
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .overFullScreen
        self.present(navigationController, animated: true, completion: nil)
    }

    @IBAction func showPrivacityPolicy(_ sender: UIButton) {
        //Using a view controller
        let vc = ContestAndPrivacyController()
        vc.url = "http://about.juegakuni.mx/privacidad.html"
        vc.dialogTitle = "Politica de privacidad"
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .overFullScreen
        self.present(navigationController, animated: true, completion: nil)
        
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
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        UIApplication.shared.statusBarStyle = .lightContent
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

