//
//  QuestionController.swift
//  Kuni
//
//  Created by Daniel on 24/09/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit

private let cellId = "cellId"

class QuestionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var levelName:String?
    var question:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(rgb: 0xEFEFF4)
        collectionView?.register(QuestionCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let questionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! QuestionCell
        questionCell.name = "Nombre"
        return questionCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let element = levels[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((view.frame.width-48)/2), height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(16, 16, 16, 16)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}

class QuestionCell: UICollectionViewCell {
    var name: String? {
        didSet {
            nameLabel.text = name
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
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    let rewardsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let levelNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    func setupViews() {
        backgroundColor = .clear
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 0.8)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.8
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
        addSubview(nameLabel)
        addSubview(rewardsLabel)
        addSubview(levelNumberLabel)
        
        addConstraintsWithFormat("V:|-10-[v0(16)]-4-[v1(12)]-55-[v2]-10-|", views: nameLabel, rewardsLabel, levelNumberLabel)
        addConstraintsWithFormat("H:|[v0]|", views: nameLabel)
        addConstraintsWithFormat("H:|[v0]|", views: rewardsLabel)
        addConstraintsWithFormat("H:|-10-[v0]-10-|", views: levelNumberLabel)
        
    }
}
