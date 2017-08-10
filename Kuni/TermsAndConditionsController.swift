//
//  TermsAndConditionsController.swift
//  Kuni
//
//  Created by Daniel on 28/07/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit


class TermsAndConditionsController: UIViewController {
    let termsFile = "TermsAndConditions.html"
    let dismissButton:UIButton! = UIButton(type:.custom)
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cerrar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(self.modalDidFinish), for: .touchUpInside)
        return button
    }()
    
    lazy var webView: UIWebView = {
        let wview = UIWebView()
        return wview
    }()
    
    
    var closeButtonTopAnchor: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set the Background color of the view.
        view.backgroundColor = UIColor(red:0.99, green:0.29, blue:0.29, alpha:1.00)
        
        
        let url = Bundle.main.path(forResource: "TermsAndConditions", ofType: "html")
        let requesturl = URL(string: url!)
        let request = URLRequest(url: requesturl!)        
        webView.loadRequest(request)
        
        view.addSubview(webView)
        view.addSubview(closeButton)
        
        closeButtonTopAnchor = closeButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50).first
        
        webView.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 60, leftConstant: 0, bottomConstant: 0, rightConstant: 0)

    }
    
    func modalDidFinish(){
        dismiss(animated: true, completion: nil)
    }
    
    
}
