//
//  ProfileController.swift
//  Kuni
//
//  Created by Daniel on 05/08/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit
import SwiftIconFont

class ProfileController: UITableViewController, EditProfileDelegate  {
    
    let sections = "Datos generales"
    let items = ["Nombre", "Apellidos", "Correo electrónico"]
    var profile:Profile?
    let icons = ["user", "user", "envelope"]

    convenience init() {
        self.init(style: .grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = addMenuButton()
        self.navigationItem.rightBarButtonItem = addEditButton()
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        getProfileData()
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

        cell.textLabel?.text = "fa:\(icons[indexPath.row]) \(items[indexPath.row])"
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.parseIcon()
        cell.textLabel?.numberOfLines = 0
        
        if let nombre = self.profile?.name {
            if items[indexPath.row] == "Nombre" {
                cell.detailTextLabel?.text = nombre
            }
        }

        if let apellidos = self.profile?.last_name {
            if items[indexPath.row] == "Apellidos" {
                cell.detailTextLabel?.text = apellidos
            }
        }
        
        if let email = self.profile?.email {
            if items[indexPath.row] == "Correo electrónico" {
                cell.detailTextLabel?.text = email
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections
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
        editProfile.delegate = self
        let navigationController = UINavigationController(rootViewController: editProfile)
        navigationController.modalPresentationStyle = .overFullScreen
        self.present(navigationController, animated: true, completion: nil)
    }

    func getProfileData(){
        AuthManager.sharedInstance.getProfile() { item, error in
            self.profile = item
            self.tableView.reloadData()
            return
        }
    }
    
    // Reloading data after user save in the Edit VC
    func userSaveProfileData(resp: Bool) {
        if(resp){
            getProfileData()
        }
    }
    
    func showMenu() {
        self.findHamburguerViewController()?.showMenuViewController()
    }
}
