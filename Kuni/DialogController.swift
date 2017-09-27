//
//  DialogController.swift
//  Kuni
//
//  Created by Daniel Martinez Segundo on 25/9/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit

protocol DialogModalDelegate {
    func dialogSerieClosed(showDashboard: Bool)
}

class DialogController: UIViewController {
    var delegate:DialogModalDelegate? = nil
    var message:String?
    var imageName:String?
    
    lazy var btnDashboard: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(UIColor(rgb: 0x505050), for: UIControlState())
        button.addTarget(self, action: #selector(goToDashboard(_:)), for: .touchUpInside)
        button.setTitle("Ir al tablero", for: UIControlState())
        button.tag = 1
        return button
    }()
    
    lazy var btnNextSerie: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(rgb: 0x97BA52)
        button.setTitleColor(.white, for: UIControlState())
        button.addTarget(self, action: #selector(nextSerie(_:)), for: .touchUpInside)
        button.setTitle("Siguiente serie", for: UIControlState())
        button.tag = 2
        return button
    }()
    
    lazy var lblMessage: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMessageData()
        
        //Main Stack View
        let container   = UIStackView()
        container.axis  = .vertical
        container.distribution  = .equalSpacing
        container.alignment = .fill
        container.spacing   = 16.0
        container.addArrangedSubview(lblMessage)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let buttons   = UIStackView()
        buttons.axis  = .horizontal
        buttons.distribution  = .fillEqually
        buttons.alignment = .bottom
        buttons.spacing   = 22
        buttons.addArrangedSubview(btnDashboard)
        buttons.addArrangedSubview(btnNextSerie)
        buttons.translatesAutoresizingMaskIntoConstraints = false

        let main = UIStackView()
        main.axis = .vertical
        main.distribution = .fillProportionally
        main.alignment = .fill
        main.spacing = 0
        main.addArrangedSubview(container)
        main.addArrangedSubview(buttons)
        main.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(main)
        view.backgroundColor = .white
        if let image = imageName {
            UIGraphicsBeginImageContext(self.view.frame.size)
            UIImage(named: image)?.draw(in: self.view.bounds)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }
        
        //Constraints
        main.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 20, rightConstant: 20)
        container.anchorToTop(main.topAnchor, left: main.leftAnchor, bottom: buttons.topAnchor, right: main.rightAnchor)
        buttons.anchorToTop(nil, left: main.leftAnchor, bottom: main.bottomAnchor, right: main.rightAnchor)
    }
    
    func setMessageData(){
        if let message = self.message {
            lblMessage.text = message
        }
        if let fileBackgroundName = self.imageName {
            imageName = fileBackgroundName
        }
    }
    
    func goToDashboard(_ sender:UIButton){
        dismissDialog(dashboard: true)
    }
    
    func nextSerie(_ sender:UIButton){
        dismissDialog(dashboard: false)
    }
    
    func dismissDialog(dashboard:Bool){
        if(delegate != nil) {
            self.delegate?.dialogSerieClosed(showDashboard: dashboard)
            let pvc = self.presentingViewController
            self.dismiss(animated: true, completion: {
                if(dashboard){
                    pvc?.presentingViewController?.dismiss(animated: true, completion: {})
                }
            })
        }
    }
    
}