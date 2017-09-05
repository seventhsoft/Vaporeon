//
//  DashboardController.swift
//  Kuni
//
//  Created by Daniel on 18/08/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit

private let cellId = "cellId"

class DashboardController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var levels = [Level]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = Level()
        item1.name = "Nivel 1"
        item1.number = 1
        item1.recompensasDisponibles = 22
        item1.series = 6
        item1.seriesJugador = 6
        item1.tieneRecompensa = true

        let item2 = Level()
        item2.name = "Nivel 2"
        item2.number = 2
        item2.recompensasDisponibles = 22
        item2.series = 6
        item2.seriesJugador = 6
        item2.tieneRecompensa = true
        
        let item3 = Level()
        item3.name = "Nivel 3"
        item3.number = 3
        item3.recompensasDisponibles = 22
        item3.series = 6
        item3.seriesJugador = 6
        item3.tieneRecompensa = true
        
        levels.append(item1)
        levels.append(item2)
        levels.append(item3)
        
        loadLevels()
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.register(LevelCell.self, forCellWithReuseIdentifier: cellId)
        self.navigationItem.leftBarButtonItem = addMenuButton()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let levelCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LevelCell
        levelCell.level = levels[indexPath.item]        
        return levelCell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((view.frame.width-48)/2), height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(16, 16, 16, 16)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    
    // MARK: - Complement Functions
    func addMenuButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(showMenu))
        button.icon(from: .FontAwesome, code: "bars", ofSize: 20)
        return button
    }
    
    func showMenu() {
        self.findHamburguerViewController()?.showMenuViewController()
    }
    
    func loadLevels(){
        
    
    }
    
}

class LevelCell: UICollectionViewCell {
    var level: Level? {
        didSet {
            if let name = level?.name {
                let attributedText = NSMutableAttributedString(string: String(name),
                    attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16)])
                attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.white , range: NSRange(location: 0, length: (String(name)?.characters.count)!))
                nameLabel.attributedText = attributedText
            }
            
            if let levelNumber = level?.number {
                levelNumberLabel.text = String(levelNumber)
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let levelNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
    func setupViews() {
        backgroundColor = .clear
        let bgView = UIImageView()
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 8
        bgView.downloadedFrom(link: "http://images.juegakuni.com.mx/images/bg_lv1_started.png", contentMode: .scaleAspectFill)
        backgroundView = bgView
        
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 0.8)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.8
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
        addSubview(nameLabel)
        addSubview(levelNumberLabel)

        addConstraintsWithFormat("V:|-10-[v0(16)]-10-[v1]-10-|", views: nameLabel,levelNumberLabel)
        addConstraintsWithFormat("H:|[v0]|", views: nameLabel)
    }
}


extension UIView {
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        let constraint = NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary)
        //constraint.
        addConstraints(constraint)
    }
    
}




