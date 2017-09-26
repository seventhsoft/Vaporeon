//
//  DialogController.swift
//  Kuni
//
//  Created by Daniel Martinez Segundo on 25/9/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit

protocol DialogModalDelegate {
    func dialogSerieClosed()
}

class DialogController: UIViewController {
    var delegate:DialogModalDelegate? = nil
    var message:String?
    var imageName:String?
    
    lazy var btnDashboard: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(UIColor(rgb: 0x505050), for: UIControlState())
        //button.addTarget(self, action: #selector(selectAnswer(_:)), for: .touchUpInside)
        button.setTitle("Ir al tablero", for: UIControlState())
        button.tag = 1
        return button
    }()
    
    lazy var btnNextSerie: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(rgb: 0x97BA52)
        button.setTitleColor(.white, for: UIControlState())
        //button.addTarget(self, action: #selector(selectAnswer(_:)), for: .touchUpInside)
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
        buttons.alignment = .fill
        buttons.spacing   = 20
        buttons.addArrangedSubview(btnDashboard)
        buttons.addArrangedSubview(btnNextSerie)
        buttons.translatesAutoresizingMaskIntoConstraints = false

        let main = UIStackView()
        main.axis = .vertical
        main.distribution = .equalSpacing
        main.alignment = .fill
        main.spacing = 20
        main.addArrangedSubview(container)
        main.addArrangedSubview(buttons)
        main.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(main)
        view.backgroundColor = .orange
        
        //Constraints
        main.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        container.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: buttons.topAnchor, right: view.rightAnchor)
        buttons.anchorWithConstantsToTop(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 20, rightConstant: 20)
        
        
    }
    
    func setMessageData(){
        if let message = self.message {
            lblMessage.text = message
        }
        
        if let fileBackgroundName = self.imageName {
            imageName = fileBackgroundName
        }
    }
    
    
    func dismissDialog(){
        if(delegate != nil) {
            self.delegate?.dialogSerieClosed()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
