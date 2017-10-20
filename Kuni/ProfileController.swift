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
    let items = ["Nombre", "Apellidos", "Correo electrónico", "Contraseña"]
    var profile:Profile?
    let icons = ["user", "user", "envelope", "key"]

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
        if let profile = self.profile {
            if(profile.facebook){
                return items.count - 1
            }
        }
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
        
        if let profile = self.profile {
            switch items[indexPath.row] {
            case "Nombre": cell.detailTextLabel?.text = profile.name
            case "Apellidos": cell.detailTextLabel?.text = profile.last_name
            case "Correo electrónico": cell.detailTextLabel?.text = profile.email
            case "Contraseña": cell.detailTextLabel?.text = String(profile.email.characters.map { _ in return "•" })
            default: break
            }
        }
        cell.textLabel?.text = "fa:\(icons[indexPath.row]) \(items[indexPath.row])"
        cell.textLabel?.parseIcon()
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.numberOfLines = 0
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
