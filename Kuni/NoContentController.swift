//
//  NoContentController.swift
//  Kuni
//
//  Created by Daniel Martinez Segundo on 29/9/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit

class NoContentController: UIViewController {
    
    var message: String?
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x5C5C5B)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "SF Pro Display", size: 16 )
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 30
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xEFEFF4)
        
        if let messageVC = self.message {
            messageLabel.text = messageVC
            stack.addArrangedSubview(messageLabel)
            
            view.addSubview(stack)
            stack.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30)
        }
    }
}
