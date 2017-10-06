//
//  LegalsController.swift
//  Kuni
//
//  Created by Daniel on 19/08/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit

class LegalsController: UITableViewController {
    let items = ["Bases del concurso", "Politica de privacidad"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = items[indexPath.row]
        cell.tag = indexPath.row
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = ""
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch items[indexPath.row] {
        case "Bases del concurso":
            showModal(url: "http://about.juegakuni.mx/bases.html", title: "Bases del concurso")
        case "Politica de privacidad":
            showModal(url: "http://about.juegakuni.mx/privacidad.html", title: "Politica de privacidad")
        default: break
        }
    }
    
    func showModal(url: String, title: String){
        //Using a view controller
        let vc = ContestAndPrivacyController()
        vc.url = url
        vc.dialogTitle = title
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .overFullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}
