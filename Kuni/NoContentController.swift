//
//  NoContentController.swift
//  Kuni
//
//  Created by Daniel Martinez Segundo on 29/9/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit

class NoContentController: UIViewController {
    private var tableView: UITableView!
    private var imageView: UIImageView!
    private var topLabel: UILabel!
    private var bottomLabel: UILabel!
    
    var message: String?
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.textColor.value
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = Font(.custom("SFProDisplay-Regular"), size: .custom(22.0)).instance
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupTableView()
        
        
//        let topMessage = ""
//        let bottomMessage = ""
//        let image = UIImage(named: "star-large")!.withRenderingMode(.alwaysTemplate)
//

        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 30
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.mainDialogBackground.value

        if let messageVC = self.message {
            messageLabel.text = messageVC
            stack.addArrangedSubview(messageLabel)
            view.addSubview(stack)
            stack.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30)
        }
    }
    
    
//    func setupTableView(){
//        tableView = UITableView.newAutoLayoutView()
//        view.addSubview(tableView)
//    }
}
