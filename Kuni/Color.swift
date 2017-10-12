//
//  Color.swift
//  Kuni
//
//  Created by Daniel on 05/10/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import Foundation
import UIKit

// Usage Examples
//let shadowColor = Color.shadow.value
//let shadowColorWithAlpha = Color.shadow.withAlpha(0.5)
//let customColorWithAlpha = Color.custom(hexString: "#123edd", alpha: 0.25).value

enum Color {
    
    case tabbar
    case navigationBar
    case navigationBatTint
    case textColor
    case titleColor
    
    case dashboardLevelInactive
    case dashboardLevelActive
    
    case questionBackground
    case classNextQuestion
    case classBackground
    case answerNormal
    case answerCorrect
    case answerFail
    
    case mainTintColor
    case mainDialogBackground
    
    case secondaryTintColor
    case secondaryBackgroundColor
    
    case menuSeparator
    case tabbarTopBorder
    
    case popupDialogBackground
    case popupTitleBarColor
    
    case onboardingTextColor
    case onboardingNextColor
    case onboardingNormalPage
    case onboardingCurrentPage
    
    case dialogBtnDashboard
    case dialogBtnDashboardText
    case dialogBtnNextSerie
    case dialogBtnNextSerieText
    
    
    case custom(hexString: String, alpha: Double)
    func withAlpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }

}

extension Color {
    
    var value: UIColor {
        var instanceColor = UIColor.clear
        
        switch self {
            
        case .custom(let hexValue, let opacity):
            instanceColor = UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))

        case .tabbar:
            instanceColor = UIColor(hexString: "#FFFFFF")
        case .navigationBar:
            instanceColor = UIColor(hexString: "#FFFFFF")
        case .dashboardLevelInactive:
            instanceColor = UIColor(hexString: "#5E5E5E")
        case .dashboardLevelActive:
            instanceColor = UIColor(hexString: "#FFFFFF")
        case .navigationBatTint:
            instanceColor = UIColor(hexString: "#FFFFFF")
        case .dialogBtnDashboard:
            instanceColor = UIColor(hexString: "#FFFFFF")
        case .dialogBtnDashboardText:
            instanceColor = UIColor(hexString: "#505050")
        case .dialogBtnNextSerie:
            instanceColor = UIColor(hexString: "#97BA52")
        case .dialogBtnNextSerieText:
            instanceColor = UIColor(hexString: "#FFFFFF")
        case .onboardingNextColor:
            instanceColor = UIColor(hexString: "#A1AAB2")
        case .onboardingTextColor:
            instanceColor = UIColor(hexString: "#A1AAB2")
        case .onboardingCurrentPage:
            instanceColor = UIColor(hexString: "#8FBA47")
        case .onboardingNormalPage:
            instanceColor = UIColor(hexString: "#A6A6A6")
        case .popupTitleBarColor:
            instanceColor = UIColor(hexString: "#3E8489")
        case .menuSeparator:
            instanceColor = UIColor(hexString: "#DCDCDC")
        case .textColor:
            instanceColor = UIColor(hexString: "#5C5C5B")
        case .titleColor:
            instanceColor = UIColor(hexString: "#E81A8D")
        case .mainTintColor:
            instanceColor = UIColor(hexString: "#E81A8D")
        case .popupDialogBackground:
            instanceColor = UIColor(hexString: "#E6F1FC")
        case .mainDialogBackground:
            instanceColor = UIColor(hexString: "#EFEFF4")
        case .tabbarTopBorder:
            instanceColor = UIColor(hexString: "#D0D0D0")
        case .secondaryTintColor:
            instanceColor = UIColor(hexString: "#1F8689")
        case .secondaryBackgroundColor:
            instanceColor = UIColor(hexString: "#1F8689")
            
        case .questionBackground:
            instanceColor = UIColor(hexString: "#3CBBBD")
        case .classBackground:
            instanceColor = UIColor(hexString: "#3CBBBD")
        case .classNextQuestion:
            instanceColor = UIColor(hexString: "#8FBA47")
        case .answerNormal:
            instanceColor = UIColor(hexString: "#505050")
        case .answerFail:
            instanceColor = UIColor(hexString: "#C00000")
        case .answerCorrect:
            instanceColor = UIColor(hexString: "#86CD00")
        }
        

        return instanceColor
    }
}

extension UIColor {
    /**
     Creates an UIColor from HEX String in "#363636" format
     
     - parameter hexString: HEX String in "#363636" format
     
     - returns: UIColor from HexString
     */
    convenience init(hexString: String) {
        
        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner          = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
}
