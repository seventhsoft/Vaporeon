//
//  RegisterController.swift
//  Kuni
//
//  Created by Daniel on 29/07/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {        
        super.viewDidLoad()
        password.delegate = self
        
    }
    
    // Signup Form
    @IBAction func signUp(_ sender: UIButton) {
        let params: Parameters = [
            "nombre" : name.text!,
            "apaterno": firstName.text!,
            "correo": email.text!,
            "usuario": email.text!,
            "password" : password.text!,
            "facebook" : false,
            "activo" : false,
            "idPerfil" : 2
        ]        
        if validateFields() {
            AuthManager.sharedInstance.signUp(params: params){ success, code in
                if(success){
                    let alert = Helpers.displayAlertMessage(
                        title: "¡Casi estás listo!",
                        messageToDisplay: "Revisa tu correo electrónico y haz clic en el enlace que te aparece para confirmar tu cuenta"
                    )
                    self.present(alert, animated: true, completion:nil)
                } else {
                    if(code == 412 || code == 409){
                        let alert = Helpers.displayAlertMessage(
                            title: "Error de registro",
                            messageToDisplay: "El correo que intentas registrar ya existe, por favor revisalo."
                        )
                        self.present(alert, animated: true, completion:nil)
                    }
                }
                return
            }

        }
    }

    // Validate fields
    func validateFields() -> Bool {
        // Create and configure Form
        let formItems:[FormItem] = configureFormItems()
        let form:Form = Form()
        form.configureItems(formItemsParams: formItems)
        let formIsValid = form.isValid().0
        
        if !formIsValid {
            let alert = Helpers.displayAlertMessage(title: "Error de registro", messageToDisplay: form.getLastMessage())
            self.present(alert, animated: true, completion:nil)
        }
        return formIsValid
    }
    
    func configureFormItems() -> [FormItem] {
        var formItems = [FormItem]()
        // Name
        let nameItem = FormItem(message: "El nombre es demasiado corto, por favor revisela.")
        nameItem.value = name.text!
        nameItem.type = "text"
        
        // First Name
        let firstNameItem = FormItem(message: "Los apellidos son demasiado cortos, por favor reviselos.")
        firstNameItem.value = firstName.text!
        firstNameItem.type = "text"
        
        // eMail
        let emailItem = FormItem(message: "La dirección de correo no es válida, por favor revisela.")
        emailItem.value = email.text!
        emailItem.type = "email"
        
        // Password
        let passwordItem = FormItem(message: "La contraseña es demasiado corta, por favor revisela.")
        passwordItem.value = password.text!
        passwordItem.type = "password"
        
        formItems = [nameItem, firstNameItem, emailItem, passwordItem]
        return formItems
        
    }
    
    // Delegate for UITetfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
