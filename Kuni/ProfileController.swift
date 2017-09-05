//
//  ProfileController.swift
//  Kuni
//
//  Created by Daniel on 05/08/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit
import SwiftIconFont

class ProfileController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    let sections = "Datos generales"
    let items = ["Nombre", "Apellidos", "Correo electrónico"]
    let icons = [""]

    convenience init() {
        self.init(style: .grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = addMenuButton()
        self.navigationItem.rightBarButtonItem = addEditButton()
        self.tableView.tableFooterView = UIView(frame: .zero)
        fetchProfileData()
        
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
        let cell = UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: "Cell")

//        cell.textLabel?.text = "io:person \(items[indexPath.row])"
//        cell.textLabel?.parseIcon()
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "Detalle"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections
    }
    
    // MARK: Load Data Functions
    
    func fetchProfileData(){
        let auth = AuthManager.sharedInstance
        auth.getProfile()
    }
    
    // MARK: Navigation Functions
    
    func addMenuButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(showMenu))
        button.icon(from: .FontAwesome, code: "bars", ofSize: 20)
        return button
    }
    
    func addEditButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(title: "Editar", style: .plain, target: self, action: #selector(showEditProfile))
        button.icon(from: .Ionicon, code: "edit", ofSize: 20)
        return button
    }
    
    func showEditProfile(_ sender: AnyObject){
        let editProfile = EditProfileController()
        
        let navigationController = UINavigationController(rootViewController: editProfile)
        navigationController.modalPresentationStyle = .overFullScreen
        
        self.present(navigationController, animated: true, completion: nil)
    }

    
    func showMenu() {
        self.findHamburguerViewController()?.showMenuViewController()
    }
}
