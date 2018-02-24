//
//  Form.swift
//  Kuni
//
//  Created by Daniel on 31/07/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import Foundation
import UIKit

class Form {
    var formItems = [FormItem]()
    
    var title: String?
    var lastMessage: String = ""
    
    init() {
        self.title = "Amazing form"
    }
    
    func configureItems(formItemsParams: [FormItem]){
        self.formItems = formItemsParams
    }
    
    // MARK: Form Validation
    func isValid() -> (Bool, String?) {
        
        var isValid = true
        for item in self.formItems {
            item.checkValidity()
            if !item.isValid {
                isValid = false
                lastMessage = item.message
            }
        }
        return (isValid, nil)
    }
    
    func getLastMessage() -> String {
        return self.lastMessage
    }
}

/// Conform receiver to have data validation behavior
protocol FormValidable {
    var isValid: Bool {get set}
    var isMandatory: Bool {get set}
    func checkValidity()
}

/// ViewModel to display and react to text events, to update data
class FormItem: FormValidable {
    
    var value: String?
    var message = ""
    var indexPath: IndexPath?
    var minSize = 4
    var type = "text"

    //var valueCompletion: ((String?) -> Void)?
    
    var hasMinSize = true
    var isMandatory = true
    var isValid = true //FormValidable
    
    // MARK: Init
    init(message: String, value: String? = nil) {
        self.message = message
        self.value = value
    }
    
    // MARK: FormValidable
    func checkValidity() {
        if self.isMandatory {
            self.isValid = self.value != nil && self.value?.isEmpty == false
            
            switch self.type {
            case "email":
                self.isValid = Validators.validEmail(emailAddress: self.value!)
                //print("Is Email Valid:  \(self.isValid)")
            case "password":
                self.isValid = !Validators.isMin(data: self.value!, min: self.minSize)
                //print("Password is too short:  \(self.isValid)")
            default:
                self.isValid = !Validators.isMin(data: self.value!, min: self.minSize)
                break
            }

        } else {
            self.isValid = true
        }
    }
}


