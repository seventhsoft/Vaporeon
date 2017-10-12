//
//  TextField.swift
//  Kuni
//
//  Created by Daniel Martinez Segundo on 11/10/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit

class KuniTextField: UITextField {

    let padding = UIEdgeInsets(top: 12, left: 5, bottom: 12, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }
    
    func setupView(){

        self.textColor = UIColor(hexString: "#545454")
        self.borderColor = UIColor(hexString: "#545454")
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
