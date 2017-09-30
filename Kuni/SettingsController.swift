//
//  SettingsController.swift
//  Kuni
//
//  Created by Daniel on 19/08/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
    
    let items = ["Notificaciones", "Sonidos"]
    
    convenience init() {
        self.init(style: .grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.sectionFooterHeight = 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        
        let switcher = UISwitch(frame: CGRect.zero) as UISwitch
        switcher.isOn = false
        switcher.addTarget(self, action: #selector(optionTriggered), for: .valueChanged)
        switcher.tag = indexPath.row
        cell.accessoryView = switcher

        return cell
    }

    

    
    func optionTriggered(_ sender: UISwitch) {
        print("Se activó switch numero: \(sender.tag)")
    }
}
