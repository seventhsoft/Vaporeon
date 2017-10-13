//
//  HomeMenuController.swift
//  Kuni
//
//  Created by Daniel on 14/08/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit

class HomeMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // outlets
    @IBOutlet weak var tableView: UITableView!
    
    // data
    //let segues = ["Ajustes", "Legales", "Salir"]
    let segues = ["Legales", "Salir"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.separatorColor = Color.menuSeparator.value
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate&DataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        cell.textLabel?.text = segues[(indexPath as NSIndexPath).row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.textLabel?.text == "Salir" {
            logout()
        } else {
            let nvc = self.mainNavigationController()
            if let hamburguerViewController = self.findHamburguerViewController() {
                hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                    nvc.visibleViewController?.performSegue(withIdentifier: self.segues[(indexPath as NSIndexPath).row], sender: nil)
                    hamburguerViewController.contentViewController = nvc as UIViewController
                })
            }
        }
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.contentView.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.contentView.backgroundColor = .clear
    }
    
    
    // MARK: - Navigation
    private func logout() {
        UserDefaults.standard.setIsLoggedIn(value: false)
        AuthManager.sharedInstance.logout()
        perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
    }
    
    func showLoginController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = UserDefaults.standard.hasSeenOnboarding() ? "LoginNavigation" : "OnboardingNavigation"
        let settingVC = storyboard.instantiateViewController(withIdentifier: homeVC) as! UINavigationController
        self.present(settingVC, animated: true, completion: {
            UIApplication.shared.keyWindow?.rootViewController = settingVC
        })
        
    }
    
    func mainNavigationController() -> DLHamburguerNavigationController {
        return self.storyboard?.instantiateViewController(withIdentifier: "HomeNavigationController") as! DLHamburguerNavigationController
    }
    
}

