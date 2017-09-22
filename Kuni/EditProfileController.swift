//
//  EditProfileController.swift
//  Kuni
//
//  Created by Daniel on 21/08/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit
import SwiftIconFont
import Alamofire


protocol EditProfileDelegate {
    func userSaveProfileData(resp: Bool)
}

class EditProfileController: UITableViewController {
    
    let sections = "Datos generales"
    var profile:Profile?
    let items = ["Nombre", "Apellidos", "Correo electrónico"]
    let icons = ["user", "user", "envelope"]
    var delegate: EditProfileDelegate? = nil
    
    convenience init() {
        self.init(style: .grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Transparent Navigation Bar
        let navBar = self.navigationController?.navigationBar
        navBar?.tintColor = .white
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navBar?.barTintColor = UIColor(rgb: 0xFC4B4A)
        navBar?.backgroundColor = UIColor(rgb: 0xFC4B4A)
        navBar?.shadowImage = UIImage()
        navBar?.isTranslucent = false
        
        let btnCancel = UIBarButtonItem(title: "Cancelar", style: .done, target: self, action: #selector(dismissDialog))
        self.navigationItem.leftBarButtonItem = btnCancel
        let btnDone = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(saveData))
        self.navigationItem.rightBarButtonItem = btnDone
        self.title = "Editar perfil"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.estimatedRowHeight = 54
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(customCell.self, forCellReuseIdentifier: "CustomCell")
        
        // Fetch profile data
        AuthManager.sharedInstance.getProfile() { item, error in
            self.profile = item
            self.tableView.reloadData()
            return
        }
    }
    
    func dismissDialog(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveData(){
        if(delegate != nil) {
            var params: Parameters = [:]
            
            for section in 0...self.tableView.numberOfSections - 1 {
                for row in 0...self.tableView.numberOfRows(inSection: section) - 1 {
                    let cell = self.tableView.cellForRow(at: NSIndexPath(row: row, section: section) as IndexPath) as! customCell
                    switch cell.tag {
                    case 0: params["nombre"] = cell.textfield.text!; break
                    case 1: params["apaterno"] = cell.textfield.text!; break
                    default: break
                    }
                }
            }
            
            AuthManager.sharedInstance.setProfile(params: params){  resp, error in
                if(resp){
                    self.delegate?.userSaveProfileData(resp: true)
                    self.dismissDialog()
                } else {
                    print("Ocurrió un error actualizando los datos :/")
                }
            }
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: "Cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! customCell
        cell.label = "fa:\(icons[indexPath.row]) \(items[indexPath.row])"
        
        if let nombre = self.profile?.name {
            if items[indexPath.row] == "Nombre" {
                cell.data = nombre
                cell.tag = 0
            }
        }
        
        if let apellidos = self.profile?.last_name {
            if items[indexPath.row] == "Apellidos" {
                cell.data = apellidos
                cell.tag = 1
            }
        }
        
        if let email = self.profile?.email {
            if items[indexPath.row] == "Correo electrónico" {
                cell.data = email
                cell.tag = 2
                cell.textfield.isUserInteractionEnabled = false
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections
    }
    
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if indexPath.section == 0 && indexPath.row == 0 {
//            //editModelTextField.becomeFirstResponder()
//        }
//        
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
    
}

class customCell: UITableViewCell, UITextFieldDelegate {
    
    var label: String? {
        didSet {
            profileLabel.text = label
            profileLabel.parseIcon()
        }
        
    }
    
    var data: String? {
        didSet {
            textfield.text = data
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textfield.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private let profileLabel: UILabel = {
        let label = UILabel()
        label.text = "This is the profile label"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    
    let textfield: UITextField = {
        let text = UITextField()
        text.placeholder = "Texto a ingresar"
        text.font = UIFont.systemFont(ofSize: 13)
        text.autocorrectionType = .no
        text.autocapitalizationType = .none
        text.adjustsFontSizeToFitWidth = true
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = ""
        return text
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //backgroundColor = .clear
        addSubview(profileLabel)
        profileLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        profileLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        profileLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        addSubview(textfield)
        textfield.leftAnchor.constraint(equalTo: profileLabel.rightAnchor, constant: 8).isActive = true
        textfield.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        textfield.heightAnchor.constraint(equalToConstant: 20).isActive = true
        textfield.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




