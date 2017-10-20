//
//  StepCell.swift
//  Kuni
//
//  Created by Daniel Martinez Segundo on 19/10/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit

class StepCell: UICollectionViewCell {
    
    var page: Page? {
        didSet {
            
            guard let page = page else {
                return
            }
            
            let image = page.imageName
            
            self.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
            let attributedText = NSMutableAttributedString(string: "\(page.message)", attributes: [NSFontAttributeName: Font(.custom("SFProDisplay-Heavy"), size: .custom(18.0)).instance, NSForegroundColorAttributeName: Color.walkthroughtTextColor.value ])
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let length = attributedText.string.characters.count
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: length))
            
            textView.attributedText = attributedText
            background.image = UIImage(named: image)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let background: UIImageView = {
        let bg = UIImageView(frame: UIScreen.main.bounds)
        bg.image = UIImage(named: "step1")
        bg.backgroundColor = .white
        bg.contentMode = .scaleAspectFit
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin, .flexibleHeight, .flexibleWidth]
        bg.clipsToBounds = true
        return bg
    }()
    
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE TEXT FOR NOW"
        tv.isEditable = false
        tv.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        tv.backgroundColor = .clear
        return tv
    }()
    
    func setupViews() {
        addSubview(textView)
        addSubview(background)
        sendSubview(toBack: background)
        
        textView.anchorWithConstantsToTop(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        textView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true

        // adding NSLayoutConstraints
        background.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        background.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        background.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        background.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

