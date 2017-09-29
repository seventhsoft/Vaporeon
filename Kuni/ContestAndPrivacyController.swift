//
//  TermsAndConditionsController.swift
//  Kuni
//
//  Created by Daniel on 28/07/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit


class ContestAndPrivacyController: UIViewController {
    var file: String?
    var dialogTitle: String?
    var url: String?
    
    lazy var webView: UIWebView = {
        let wview = UIWebView()
        return wview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the Background color of the view.
        view.backgroundColor = UIColor(rgb: 0xE6F1FC)
        let navBar = self.navigationController?.navigationBar
        navBar?.tintColor = .white
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navBar?.barTintColor = UIColor(rgb: 0x3E8489)
        navBar?.backgroundColor = UIColor(rgb: 0x3E8489)
        navBar?.shadowImage = UIImage()
        navBar?.isTranslucent = false
        
        let btnDone = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(modalDidFinish))
        self.navigationItem.rightBarButtonItem = btnDone

        if let mainTitle = dialogTitle {
            self.title = mainTitle
        }
        
        if let fileName = file {
            if let url = Bundle.main.path(forResource: fileName, ofType: "html") {
                let requesturl = URL(string: url)
                let request = URLRequest(url: requesturl!)
                webView.loadRequest(request)
            }
        }
        
        if let urlAddress = url {
            let requesturl = URL(string: urlAddress)
            let request = URLRequest(url: requesturl!)
            webView.loadRequest(request)
        }
        
        view.addSubview(webView)
        webView.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        UIApplication.shared.statusBarStyle = .default
    }
    
    
    
    func modalDidFinish(){
        dismiss(animated: true, completion: nil)
    }
    
}
