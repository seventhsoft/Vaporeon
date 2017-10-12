//
//  Button.swift
//  Kuni
//
//  Created by Daniel Martinez Segundo on 11/10/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit

class KuniButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        self.contentEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 0)
        self.layer.cornerRadius = 4
        self.titleLabel?.font = Font(.custom("SFProDisplay-Medium"), size: .custom(16.0)).instance
        self.addShadow(offset: CGSize(width: -1, height: 1), color: UIColor.black, radius: 2, opacity: 0.5)
        
    }
}
