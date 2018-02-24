//
//  Validators.swift
//  Kuni
//
//  Created by Daniel on 30/07/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import Foundation

// MARK: Form Validators
class Validators {
    init(){}

    static func validEmail(emailAddress: String) -> Bool {
        var returnValue = true
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddress as NSString
            let results = regex.matches(in: emailAddress, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0 {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    static func isMin(data: String, min: Int) -> Bool {
        let length = data.count
        if (length < min){
            return true
        } else {
            return false
        }
    }
    
}
