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
    var contestData:ContestData?
    var gamerLevel:GamerLevel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevels()
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(rgb: 0xEFEFF4)
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
        return CGSize(width: ((view.frame.width-48)/2), height: 140)
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
        ContestManager.sharedInstance.getContestData() { data, error in
            if let contest = data["concurso"].dictionary {
                if let activo = contest["activo"]?.bool,
                    let finicio = contest["fechaInicio"]?.int,
                    let ffin = contest["fechaFin"]?.int,
                    let id = contest["idConcurso"]?.int {
                    self.contestData?.activo = activo
                    self.contestData?.fechaFin = finicio
                    self.contestData?.fechaInicio = ffin
                    self.contestData?.idConcurso = id
                }
            }
            
            if let jugador = data["jugadorNivel"].dictionary {
                if let idJugadorNivel = jugador["idJugadorNivel"]?.int,
                    let serieActual = jugador["serieActual"]?.int,
                    let dNivel = jugador["dNivel"]?.int {
                    self.gamerLevel?.idJugadorNivel = idJugadorNivel
                    self.gamerLevel?.serieActual = serieActual
                    self.gamerLevel?.dNivel = dNivel
                }
            }
            
            if let levels = data["niveles"].array {
                for level in levels {
                    let item = Level()
                    if let id = level["nivel"].int,
                        let rewards = level["recompensasDisponibles"].int,
                        let series = level["series"].int,
                        let gamerSeries = level["seriesJugador"].int,
                        let hasReward = level["tieneRecompensa"].bool,
                        let dNivel = data["jugadorNivel"]["dNivel"].int {
                        item.number = id
                        item.name = "Nivel \(id)"
                        item.recompensasDisponibles = rewards
                        item.series = series
                        item.seriesJugador = gamerSeries
                        item.tieneRecompensa = hasReward
                        item.isActive = (id <= dNivel) ? true : false
                    }
                    self.levels.append(item)
                }
            }

            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
            return
        }
    }
    
}

class LevelCell: UICollectionViewCell {
    var level: Level? {
        didSet {

            if let name = level?.name,
                let levelNumber = level?.number,
                let seriesJugador = level?.seriesJugador,
                let series = level?.series,
                let active = level?.isActive {
                
                var imgURL = "http://images.juegakuni.com.mx/images/bg_lv\(levelNumber)_unstarted.png"
                if active {
                    imgURL = "http://images.juegakuni.com.mx/images/bg_lv\(levelNumber)_started.png"
                    nameLabel.textColor = .white
                    levelNumberLabel.textColor = .white
                    rewardsLabel.textColor = .white
                }
                
                let bgView = UIImageView()
                bgView.layer.masksToBounds = true
                bgView.layer.cornerRadius = 8
                bgView.downloadedFrom(link: imgURL, contentMode: .scaleAspectFill)
                self.backgroundView = bgView
                
                levelNumberLabel.text = "\(seriesJugador)/\(series)"
                nameLabel.text = name
            }
            
            if let hasRewards = level?.tieneRecompensa {
                if hasRewards {
                    if let rewards = level?.recompensasDisponibles {
                        print("¡Aquí hay \(rewards) premios!")
                        rewardsLabel.text = "¡Aquí hay \(rewards) premios!"
                    }
                }
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




