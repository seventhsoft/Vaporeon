//
//  DashboardController.swift
//  Kuni
//
//  Created by Daniel on 18/08/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit

private let cellId = "cellId"

class DashboardController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SerieModalDelegate {
    
    var levels = [Level]()
    var contestData:ContestData?
    var gamerLevel:GamerLevel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevels()
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightHeavy),
            NSForegroundColorAttributeName : Color.titleColor.value
        ]
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = Color.mainDialogBackground.value
        collectionView?.register(LevelCell.self, forCellWithReuseIdentifier: cellId)
        self.navigationItem.leftBarButtonItem = addMenuButton()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let levelCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LevelCell
        levelCell.level = levels[indexPath.item]
        if levels[indexPath.item].isEnabled! == false {
            levelCell.nameLabel.textColor = .black
            levelCell.levelNumberLabel.textColor = .black
            levelCell.rewardsLabel.textColor = .black
        }
        
        return levelCell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let levelCell = collectionView.cellForItem(at: indexPath) as! LevelCell
        if let element = levelCell.level {
            if let isActive = element.isActive {
                if isActive {
                    let sc = SerieController()
                    if let idJugador = gamerLevel?.idJugadorNivel,
                        let idConcurso = contestData?.idConcurso,
                        let idNivel = gamerLevel?.dNivel,
                        let idSerie = gamerLevel?.serieActual {
                        sc.idJugadorNivel = idJugador
                        sc.idConcurso = idConcurso
                        sc.idNivel = idNivel
                        sc.idSerie = idSerie
                    }
                    sc.delegate = self
                    let nc = UINavigationController(rootViewController: sc)
                    nc.modalPresentationStyle = .fullScreen
                    self.present(nc, animated: true, completion: nil)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((view.frame.width-48)/2), height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(16, 16, 16, 16)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func serieDialogCanceled(){
        levels = [Level]()
        loadLevels()        
        //collectionView?.reloadData()
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
                let contestDataObj = ContestData()
                if let activo = contest["activo"]?.bool,
                    let finicio = contest["fechaInicio"]?.int,
                    let ffin = contest["fechaFin"]?.int,
                    let id = contest["idConcurso"]?.int {
                    contestDataObj.activo = activo
                    contestDataObj.fechaFin = finicio
                    contestDataObj.fechaInicio = ffin
                    contestDataObj.idConcurso = id
                }
                self.contestData = contestDataObj
            }
            
            if let jugador = data["jugadorNivel"].dictionary {
                let gamerLevelObj = GamerLevel()
                if let idJugadorNivel = jugador["idJugadorNivel"]?.int,
                    let serieActual = jugador["serieActual"]?.int,
                    let dNivel = jugador["dNivel"]?.int {
                    gamerLevelObj.idJugadorNivel = idJugadorNivel
                    gamerLevelObj.serieActual = serieActual
                    gamerLevelObj.dNivel = dNivel
                }
                self.gamerLevel = gamerLevelObj
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
                        item.isActive = (id == dNivel) ? true : false
                        item.isEnabled = (id <= dNivel) ? true : false
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
                let enabled = level?.isEnabled {

                var imgURL = "http://images.juegakuni.com.mx/images/bg_lv\(levelNumber)_unstarted.png"
                if enabled {
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
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 3).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
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




