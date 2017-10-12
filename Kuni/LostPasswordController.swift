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
    @IBOutlet weak var recuperarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recuperarButton.titleLabel?.font = Font(.custom("SFProDisplay-Medium"), size: .custom(16.0)).instance
        recuperarButton.contentEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 0)
        recuperarButton.addShadow(offset: CGSize(width: -1, height: 1), color: UIColor.black, radius: 2, opacity: 0.5)
        email.delegate = self
        
    }
    
    
    @IBAction func restorePassword(_ sender: UIButton) {
        let params: Parameters = [
            "usuario": email.text!
        ]
        
        if validateFields() {
            let auth = AuthManager.sharedInstance
            auth.lostPassword(params: params, ref: self)
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
