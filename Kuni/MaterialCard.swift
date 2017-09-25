//
//  MaterialCard.swift
//  Kuni
//
//  Created by Daniel on 24/09/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit


public class MaterialCard: UIView {
    
    var radius: CGFloat = 2
    
    var shadowOffsetWidth: Int = 0
    var shadowOffsetHeight: Int = 2
    var viewShadowColor: UIColor? = UIColor.black
    var viewShadowOpacity: Float = 0.4
    
    override public func layoutSubviews() {
        
        layer.cornerRadius = radius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
        
        layer.masksToBounds = false
        layer.shadowColor = viewShadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowOpacity = viewShadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    
}

