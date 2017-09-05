//
//  LegalsController.swift
//  Kuni
//
//  Created by Daniel on 19/08/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit

class LegalsController: UITableViewController {
    
    let items = ["Bases del concurso", "Aviso de privacidad"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "Detalle"
        return cell
    }
}
