//
//  RewardsController.swift
//  Kuni
//
//  Created by Daniel on 05/08/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit

class RewardsController: UIViewController {
    
    var segmentedControl = UISegmentedControl(items: ["Mis premios", "Premios del consurso"])
    
    private lazy var myRewardsController: MyRewardsController = {
        // Instantiate View Controller
        var viewController = MyRewardsController()
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()

    private lazy var contestRewardsController: ContestRewardsController = {
        // Instantiate View Controller
        var viewController = ContestRewardsController()
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = addMenuButton()
        self.navigationItem.backBarButtonItem?.title = "<"
        setupView()
    }
    
    
    // MARK: - View Methods
    func addMenuButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(showMenu))
        button.icon(from: .FontAwesome, code: "bars", ofSize: 20)
        return button
    }
    
    func showMenu() {
        self.findHamburguerViewController()?.showMenuViewController()
    }
    
    private func setupView() {
        setupSegmentedControl()
        updateView()
    }
    
    private func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: contestRewardsController)
            add(asChildViewController: myRewardsController)
        } else {
            remove(asChildViewController: myRewardsController)
            add(asChildViewController: contestRewardsController)
        }
    }
    
    private func setupSegmentedControl() {
        // Configure Segmented Control
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Mis premios", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Premios del concurso", at: 1, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        
        // Select First Segment
        segmentedControl.selectedSegmentIndex = 0
        self.navigationItem.titleView = segmentedControl
        //view.addSubview(segmentedControl)
    }
    
    
    // MARK: - Actions
    
    func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    // MARK: - Helper Methods
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        
        viewController.view.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)

        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
}
