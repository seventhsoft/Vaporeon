//
//  SerieController.swift
//  Kuni
//
//  Created by Daniel on 23/09/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol SerieModalDelegate {
    func serieDialogCanceled()
}

class SerieController: UIViewController, DialogModalDelegate {
    
    var delegate: SerieModalDelegate? = nil
    var idJugadorNivel: Int?
    var serie: Serie?
    var currentQuestion = 0
    var serieEnded = false
    var score = 0

    private lazy var backgroundView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor(rgb: 0x3CBBBD)
        bgView.layer.masksToBounds = false
        bgView.layer.cornerRadius = 8
        bgView.layer.shadowColor = UIColor.red.cgColor
        bgView.layer.shadowOffset = CGSize(width: -1, height: 1)
        bgView.layer.shadowOpacity = 0.4
        bgView.layer.shadowPath = UIBezierPath(roundedRect: bgView.bounds, cornerRadius: 3).cgPath
        bgView.layer.shouldRasterize = true
        return bgView
    }()
    
    private lazy var backgroundClass: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor(rgb: 0x3CBBBD)
        bgView.layer.masksToBounds = false
        bgView.layer.cornerRadius = 8
        bgView.layer.shadowColor = UIColor.red.cgColor
        bgView.layer.shadowOffset = CGSize(width: -1, height: 1)
        bgView.layer.shadowOpacity = 0.4
        bgView.layer.shadowPath = UIBezierPath(roundedRect: bgView.bounds, cornerRadius: 3).cgPath
        bgView.layer.shouldRasterize = true
        return bgView
    }()
    
    private lazy var classView: UIView = {
        let itemView = UIView()
        itemView.backgroundColor = UIColor(rgb: 0xEFEFF4)
        return itemView
    }()
    
    lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var answer1: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "answerBackground") as UIImage?
        button.backgroundColor = .clear
        button.contentMode = .scaleToFill
        button.setBackgroundImage(image, for: UIControlState())
        button.setTitleColor(UIColor(rgb: 0x505050), for: UIControlState())
        button.addTarget(self, action: #selector(selectAnswer(_:)), for: .touchUpInside)
        button.tag = 1
        return button
    }()
    
    lazy var answer2: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "answerBackground") as UIImage?
        button.backgroundColor = .clear
        button.contentMode = .scaleToFill
        button.setBackgroundImage(image, for: UIControlState())
        button.setTitleColor(UIColor(rgb: 0x505050), for: UIControlState())
        button.addTarget(self, action: #selector(selectAnswer(_:)), for: .touchUpInside)
        button.tag = 2
        return button
    }()

    lazy var answer3: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "answerBackground") as UIImage?
        button.backgroundColor = .clear
        button.contentMode = .scaleToFill
        button.setBackgroundImage(image, for: UIControlState())
        button.setTitleColor(UIColor(rgb: 0x505050),  for: UIControlState())
        button.addTarget(self, action: #selector(selectAnswer(_:)), for: .touchUpInside)
        button.tag = 3
        return button
    }()
    
    lazy var responseDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var classDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(rgb: 0x505050)
        label.textAlignment = .center
        return label
    }()
    
    lazy var nextQuestionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(rgb: 0x8FBA47)
        button.setTitleColor(.white, for: UIControlState())
        button.setTitle("Siguiente", for: UIControlState())
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(sendButtonClassFeedback(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Transparent Navigation Bar
        let navBar = self.navigationController?.navigationBar
        navBar?.tintColor = UIColor(rgb: 0xE81A8D)
        navBar?.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightHeavy),
            NSForegroundColorAttributeName : UIColor(rgb: 0xE81A8D)
        ]
        navBar?.barTintColor = .white
        navBar?.backgroundColor = .white
        navBar?.shadowImage = UIImage()
        navBar?.isTranslucent = false
        
        let btnCancel = UIBarButtonItem(title: "Abandonar", style: .done, target: self, action: #selector(dismissDialog))
        self.navigationItem.leftBarButtonItem = btnCancel
        
        view.backgroundColor = UIColor(rgb: 0xEFEFF4)
        self.title = "KUNI"
        
        if let idGamer = idJugadorNivel {
            getSerieData(id: idGamer)
        } else {
            print("No hay idJugadorNivel")
        }
    }

    func getSerieData(id: Int){
        let params: Parameters = [ "idJugadorNivel": id ]
        ContestManager.sharedInstance.getSerieData(params: params){ data, error in
            if data != JSON.null {
                let serieItem = Serie()
                if let tiempoPregunta = data["tiempoPregunta"].int {
                    serieItem.tiempo = tiempoPregunta
                }
                
                if let questions = data["preguntas"].array {
                    for question in questions {
                        let questionItem = Question()
                        if let idPregunta = question["idPregunta"].int,
                        let descripcion = question["descripcion"].string,
                        let ruta = question["ruta"].string,
                        let clase = question["clase"].string,
                        let banner = question["bannerPregunta"].string,
                        let activo = question["activo"].bool,
                        let respuestas = question["respuestaList"].array {
                            questionItem.idPregunta = idPregunta
                            questionItem.descripcion = descripcion
                            questionItem.ruta = ruta
                            questionItem.clase = clase
                            questionItem.banner = banner
                            questionItem.activo = activo
                            
                            for resp in respuestas {
                                let respItem = Answer()
                                if let idRespuesta = resp["idRespuesta"].int,
                                let descripcion = resp["descripcion"].string,
                                let orden = resp["orden"].int,
                                let correcta = resp["correcta"].bool,
                                let activo = resp["activo"].bool {
                                    respItem.idRespuesta = idRespuesta
                                    respItem.descripcion = descripcion
                                    respItem.orden = orden
                                    respItem.correcta = correcta
                                    respItem.activo = activo
                                }
                                questionItem.respuestas.append(respItem)
                            }
                            
                            serieItem.questions.append(questionItem)
                        }
                    }
                
                }
                self.serie = serieItem
                self.setControls()
                self.startSerie()
            }
        }
        
    }

    func setControls(){
        //Main Stack View
        let container   = UIStackView()
        container.axis  = .vertical
        container.distribution  = .equalSpacing
        container.alignment = .fill
        container.spacing   = 16.0
        container.addArrangedSubview(questionLabel)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layoutMargins = UIEdgeInsets(top: 30, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        
        let buttons = UIStackView()
        buttons.axis = .vertical
        buttons.distribution = .equalSpacing
        buttons.alignment = .fill
        buttons.spacing = 10
        buttons.addArrangedSubview(answer1)
        buttons.addArrangedSubview(answer2)
        buttons.addArrangedSubview(answer3)
        buttons.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(container)
        view.addSubview(buttons)
        view.addSubview(classView)
        pinBackground(backgroundView, to: container)
        
        //Constraints
        container.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: buttons.topAnchor, right: view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 30, rightConstant: 20)
        buttons.anchorWithConstantsToTop(nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 20, rightConstant: 20)
        classView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
    }
    
    func setClassView(){
        //Main Stack View
        let container   = UIStackView()
        container.axis  = .vertical
        container.distribution  = .equalSpacing
        container.alignment = .fill
        container.spacing   = 16.0
        container.addArrangedSubview(responseDescription)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layoutMargins = UIEdgeInsets(top: 30, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        
        let main = UIStackView()
        main.axis = .vertical
        main.distribution = .equalSpacing
        main.alignment = .fill
        main.spacing = 10
        main.addArrangedSubview(container)
        main.addArrangedSubview(classDescription)
        main.addArrangedSubview(nextQuestionButton)
        main.translatesAutoresizingMaskIntoConstraints = false
        
        classView.addSubview(main)
        pinBackground(backgroundClass, to: container)
        
        //Constraints
        main.anchorWithConstantsToTop(classView.topAnchor, left: classView.leftAnchor, bottom: classView.bottomAnchor, right: classView.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 20, rightConstant: 20)
        container.heightAnchor.constraint(equalTo: classView.heightAnchor, multiplier: 0.4).isActive = true
    }
    
    func startSerie(){
        // Set global markers by serie
        serieEnded = false
        score = 0
        currentQuestion = 0
        classView.isHidden = true
        showQuestion(0)
        setClassView()
        
    }
    
    func showQuestion(_ questionId : Int) -> Void {
        enableButtons()
        if let serieItem = self.serie {
            let selectedQuestion : Question = serieItem.questions[questionId]
            questionLabel.text = selectedQuestion.descripcion
            answer1.setTitle(selectedQuestion.respuestas[0].descripcion, for: UIControlState())
            answer2.setTitle(selectedQuestion.respuestas[1].descripcion, for: UIControlState())
            answer3.setTitle(selectedQuestion.respuestas[2].descripcion, for: UIControlState())
        }
    }
    
    func disableButtons() -> Void {
        answer1.isEnabled = false
        answer2.isEnabled = false
        answer3.isEnabled = false
    }
    
    func enableButtons() -> Void {
        answer1.isEnabled = true
        answer1.setTitleColor(UIColor(rgb: 0x505050),  for: UIControlState())
        answer2.isEnabled = true
        answer2.setTitleColor(UIColor(rgb: 0x505050),  for: UIControlState())
        answer3.isEnabled = true
        answer3.setTitleColor(UIColor(rgb: 0x505050),  for: UIControlState())
    }
    
    func selectAnswer(_ sender:UIButton){
        let answerId = sender.tag - 1
        disableButtons()
        if let serieItem = self.serie {
            let answers = serieItem.questions[currentQuestion].respuestas
            let answered = serieItem.questions[currentQuestion].respuestas[answerId]
            sender.setTitleColor(.red, for: UIControlState())
            if (answered.correcta == true) {
                self.score += 1
                sender.setTitleColor(.green, for: UIControlState())
            }
            
            var correct:Answer?
            for (index,element) in answers.enumerated() {
                if element.correcta == true {
                    correct = element
                    if let btnCorrect = view.viewWithTag(index+1) as? UIButton {
                        btnCorrect.setTitleColor(.green, for: UIControlState())
                    }
                }
            }
            
            delayWithSeconds(2) {
                self.setClassFeedback(answered, correct: correct)
            }
        }
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func setClassFeedback(_ answer: Answer, correct: Answer?){
        if let serie = self.serie {
            if let item = correct {
                responseDescription.text = item.descripcion
                classDescription.text = serie.questions[currentQuestion].clase
                self.getClassImage() { image, error in
                    let usedImage = (error == false) ? image : UIImage(named: "defaultClassImage")
                    UIGraphicsBeginImageContext(self.backgroundClass.frame.size)
                    usedImage?.draw(in: self.backgroundClass.bounds)
                    let otherImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                    UIGraphicsEndImageContext()
                    self.backgroundClass.backgroundColor = UIColor(patternImage: otherImage)
                    return
                }
            }
            classView.isHidden = false
        }
    }
    
    
    func sendButtonClassFeedback(_ sender: AnyObject){
        classView.isHidden = true
        
        if serieEnded == true {
            // Pantalla de fin de serie
            print("Fin de serie")
        } else {
            // Siguiente pregunta
            nextQuestion()
        }
    }
    func getClassImage(completionHandler: @escaping (UIImage, Bool?) -> ()) {
        fetchClassImage(completionHandler: completionHandler)
    }
    
    func fetchClassImage(completionHandler: @escaping (UIImage, Bool?) -> ()) {
        if let serie = self.serie {
            let imgPath = serie.questions[currentQuestion].ruta
            let link = "http://images.juegakuni.com.mx/images/clase/\(imgPath!)"
            guard let url = URL(string: link) else { return }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else {
                        completionHandler(UIImage(), true)
                        return
                }
                DispatchQueue.main.async() { () -> Void in
                    completionHandler(image, false)
                }
            }.resume()
        }
    }
    
    func nextQuestion() {
        currentQuestion += 1
        if (currentQuestion < (self.serie?.questions.count)!) {
            showQuestion(currentQuestion)
        } else {
            endSerie()
        }
    }
    
    func endSerie() {
        serieEnded = true
        print("Serie terminada")
        showEndedSerieDialog()
        classView.isHidden = true
    }
    
    func showEndedSerieDialog(){
        let dialog = DialogController()
        dialog.message = "¡Terminaste la serie!"
        dialog.imageName = "serieImage"
        dialog.delegate = self
        dialog.modalPresentationStyle = .fullScreen
        self.present(dialog, animated: true, completion: nil)
    }
    
    func dialogSerieClosed(showDashboard:Bool){
        if(!showDashboard){
            if let idGamer = idJugadorNivel {
                getSerieData(id: idGamer)
                startSerie()
            }
        }
    }
    
    
    //MARK: - Custom Function
    
    func dismissDialog(){
        if(delegate != nil) {
            self.delegate?.serieDialogCanceled()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func pinBackground(_ view: UIView, to stackView: UIStackView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.insertSubview(view, at: 0)
        view.pin(to: stackView)
    }
    
    //MARK: - Appear Functions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
}

