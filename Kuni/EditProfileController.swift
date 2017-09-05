//
//  EditProfileController.swift
//  Kuni
//
//  Created by Daniel on 21/08/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit
import SwiftIconFont

class EditProfileController: UITableViewController {
    
    let sections = "Datos generales"
    let items = ["Nombre", "Apellidos", "Correo electrónico"]
    let icons = ["ti:badge","ti:badge","ti:email"]
    
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
        
        fetchProfileData()
    }
    
    func dismissDialog(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveData(){
    
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
        cell.label = "\(icons[indexPath.row]) \(items[indexPath.row])"
        cell.data = "Data"
        

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
    

    
    // MARK: Load Data Functions
    
    func fetchProfileData(){
        
        
    }
    
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
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    
    private let textfield: UITextField = {
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
        profileLabel.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
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




