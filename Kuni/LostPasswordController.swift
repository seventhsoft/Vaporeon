//
//  LostPasswordController.swift
//  Kuni
//
//  Created by Daniel on 30/07/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LostPasswordController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        
    }
    
    
    @IBAction func restorePassword(_ sender: UIButton) {
        print("\n\n\nRecuperar contraseña \n\n\n")
        let params: Parameters = [
            "usuario": email.text!
        ]
        
        if validateFields() {
        let request = Alamofire.request(KuniRouter.lostPassword(parameters: params))
            .validate()
            .responseString { response in
                
                Debug.printDebugInfo(response: response)
                
                switch response.result {
                case .success:
                    let alert = Helpers.displayAlertMessage(title: "Te enviamos un correo", messageToDisplay: "Revisa tu correo electrónico y haz clic en el enlace que te aparece para restablecer tu contraseña")
                    self.present(alert, animated: true, completion:nil)
                    
                    print("Validation Successful")
                    
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

    // Validate fields
    func validateFields() -> Bool {
        // Create and configure Form
        let formItems:[FormItem] = configureFormItems()
        let form:Form = Form()
        form.configureItems(formItemsParams: formItems)
        let formIsValid = form.isValid().0
        
        if !formIsValid {
            let alert = Helpers.displayAlertMessage(title: "Datos incorrectos", messageToDisplay: form.getLastMessage())
            self.present(alert, animated: true, completion:nil)
        }
        return formIsValid
    }
    
    func configureFormItems() -> [FormItem] {
        var formItems = [FormItem]()
        // eMail
        let emailItem = FormItem(message: "La dirección de correo no es válida, por favor revisela.")
        emailItem.value = email.text!
        emailItem.type = "email"
    
        
        formItems = [emailItem]
        return formItems
        
    }
    
    
    // Delegate for UITetfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
