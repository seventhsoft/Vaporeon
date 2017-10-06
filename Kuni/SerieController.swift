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
    // MARK: - Context variables
    
    var delegate: SerieModalDelegate? = nil
    var idJugadorNivel: Int?
    var idConcurso: Int?
    var idNivel: Int?
    var idSerie: Int?
    var serie: Serie?
    var currentQuestion = 0
    var hasChangedLevel = false
    var serieEnded = false
    var isIncorrect = false
    var score = 0
    
    // MARK: - Context View
    private var roundRect: UIView = {
        let rect = UIView()
        rect.backgroundColor = UIColor(rgb: 0x3CBBBD)
        rect.layer.cornerRadius = 8
        rect.addShadow(offset: CGSize(width: -1, height: 1), color: UIColor.black, radius: 3, opacity: 0.5)
        rect.translatesAutoresizingMaskIntoConstraints = false
        return rect
    }()

    
    private lazy var backgroundClass: UIView = {
        let rect = UIView()
        rect.backgroundColor = UIColor(rgb: 0x3CBBBD)
        rect.layer.cornerRadius = 8
        rect.addShadow(offset: CGSize(width: -1, height: 1), color: UIColor.black, radius: 3, opacity: 0.5)
        rect.translatesAutoresizingMaskIntoConstraints = false
        return rect
    }()
    
    private lazy var classView: UIView = {
        let itemView = UIView()
        itemView.backgroundColor = UIColor(rgb: 0xEFEFF4)
        return itemView
    }()
    
    // MARK: - Labels and buttons for Question view
    
    lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()

    lazy var questionLevelSerieLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var questionNumberLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var questionCounter: EFCountingLabel = {
        let label = EFCountingLabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.text = "0"
        label.format = "%d"
        label.method = .linear
        label.animationDuration = 5.0
        label.textAlignment = .right
        return label
    }()
    
    lazy var answer1: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "answerBackground") as UIImage?
        button.backgroundColor = .clear
        button.contentMode = .scaleToFill
        button.setBackgroundImage(image, for: UIControlState())
        button.setTitleColor(UIColor(rgb: 0x505050), for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.titleLabel?.lineBreakMode = .byWordWrapping
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
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.titleLabel?.lineBreakMode = .byWordWrapping
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
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.addTarget(self, action: #selector(selectAnswer(_:)), for: .touchUpInside)
        button.tag = 3
        return button
    }()
    
    // MARK: - Labels and buttons for Class View
    lazy var responseLeyend: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .left
        label.text = "Respuesta correcta:"
        return label
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
        let levelLabels = getStackView(orientation: .vertical, spacing: 3)
        levelLabels.addArrangedSubview(questionLevelSerieLabel)
        levelLabels.addArrangedSubview(questionNumberLabel)
        
        let header = getStackView(orientation: .horizontal, spacing: 1)
        header.alignment = .top
        header.addArrangedSubview(levelLabels)
        header.addArrangedSubview(questionCounter)
        
        let cardQuestion   = getStackView(orientation: .vertical, spacing: 16)
        cardQuestion.layoutMargins = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        cardQuestion.isLayoutMarginsRelativeArrangement = true
        cardQuestion.addArrangedSubview(header)
        cardQuestion.addArrangedSubview(questionLabel)

        let buttons = getStackView(orientation: .vertical, spacing: 10)
        buttons.addArrangedSubview(answer1)
        buttons.addArrangedSubview(answer2)
        buttons.addArrangedSubview(answer3)
        
        // Set Scroll View
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // Main subviews
        self.view.addSubview(scrollView)
        self.view.addSubview(classView)
        
        //Constraints
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        roundRect.addSubview(cardQuestion)
        scrollView.addSubview(roundRect)
        scrollView.addSubview(buttons)
    
        roundRect.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9).isActive = true
        roundRect.heightAnchor.constraint(equalTo: cardQuestion.heightAnchor).isActive = true
        
        roundRect.anchorWithConstantsToTop(scrollView.topAnchor, left: scrollView.leftAnchor, bottom: buttons.topAnchor, right: scrollView.rightAnchor, topConstant: 20, leftConstant: 18, bottomConstant: 40, rightConstant: 18)
        
        cardQuestion.topAnchor.constraint(equalTo: roundRect.topAnchor, constant: 0).isActive = true
        cardQuestion.leadingAnchor.constraint(equalTo: roundRect.leadingAnchor, constant: 0).isActive = true
        cardQuestion.bottomAnchor.constraint(equalTo: roundRect.bottomAnchor, constant: 0).isActive = true
        cardQuestion.trailingAnchor.constraint(equalTo: roundRect.trailingAnchor, constant: 0).isActive = true
        
        //Buttons constraints
        buttons.anchorWithConstantsToTop(nil, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        // Class View Constraints
        classView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
    }
    
    func getStackView(orientation: UILayoutConstraintAxis, spacing: Int ) -> UIStackView {
        let stack = UIStackView()
        stack.axis = orientation
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.spacing = CGFloat(spacing)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }
    
    func setClassView(){
        //Main Stack View
        let container   = getStackView(orientation: .vertical, spacing: 16)
        container.addArrangedSubview(responseLeyend)
        container.addArrangedSubview(responseDescription)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layoutMargins = UIEdgeInsets(top: 30, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        
        backgroundClass.addSubview(container)
        
        let main = getStackView(orientation: .vertical, spacing: 10)
        main.addArrangedSubview(backgroundClass)
        main.addArrangedSubview(classDescription)
        main.addArrangedSubview(nextQuestionButton)
        main.translatesAutoresizingMaskIntoConstraints = false
        
        classView.addSubview(main)
        
        //Constraints
        main.anchorWithConstantsToTop(classView.topAnchor, left: classView.leftAnchor, bottom: classView.bottomAnchor, right: classView.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 20, rightConstant: 20)
        
        //container.heightAnchor.constraint(equalTo: classView.heightAnchor, multiplier: 0.4).isActive = true
        backgroundClass.widthAnchor.constraint(equalTo: main.widthAnchor).isActive = true
        backgroundClass.heightAnchor.constraint(equalTo: main.heightAnchor, multiplier: 0.4).isActive = true
        
        backgroundClass.anchorToTop(main.topAnchor, left: main.leftAnchor, bottom: nil, right: main.rightAnchor)
        
        container.topAnchor.constraint(equalTo: backgroundClass.topAnchor, constant: 0).isActive = true
        container.leadingAnchor.constraint(equalTo: backgroundClass.leadingAnchor, constant: 0).isActive = true
        container.bottomAnchor.constraint(equalTo: backgroundClass.bottomAnchor, constant: 0).isActive = true
        container.trailingAnchor.constraint(equalTo: backgroundClass.trailingAnchor, constant: 0).isActive = true
        
        
    }
    
    func startSerie(){
        // Set global markers by serie
        serieEnded = false
        hasChangedLevel = false
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
            if let idNivel = self.idNivel,
                let idSerie = self.idSerie {
                questionLevelSerieLabel.text = "Nivel \(idNivel)/ Serie \(idSerie)"
                questionNumberLabel.text = "Pregunta \(questionId + 1)"
            }
            if let timeInterval = serieItem.tiempo {
                // Start question counter
                questionCounter.countFrom(CGFloat(timeInterval), to: 0, withDuration: 9.0)
                questionCounter.completionBlock = { () in
                    self.checkAnswer(timerHasFinished: true)
                }
            }
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
    
    func checkAnswer(timerHasFinished: Bool){
        disableButtons()
        if timerHasFinished {
            if let serieItem = self.serie {
                delayWithSeconds(2) {
                    var correct:Answer?
                    let answers = serieItem.questions[self.currentQuestion].respuestas
                    for element in answers {
                        if element.correcta == true {
                            correct = element
                        }
                    }
                    self.isIncorrect = true
                    self.setClassFeedback(correct!, correct: correct)
                }
            }
        }
    }
    
    func selectAnswer(_ sender:UIButton){
        let answerId = sender.tag - 1
        questionCounter.stopCount()
        disableButtons()
        if let serieItem = self.serie {
            let answers = serieItem.questions[currentQuestion].respuestas
            let answered = serieItem.questions[currentQuestion].respuestas[answerId]
            sender.setTitleColor(UIColor(rgb: 0xC00000), for: UIControlState())
            
            if (answered.correcta == true) {
                self.score += 1
                sender.setTitleColor(UIColor(rgb: 0x86CD00), for: UIControlState())
                self.isIncorrect = false
            } else {
                self.isIncorrect = true
            }

            var correct:Answer?
            for (index,element) in answers.enumerated() {
                if element.correcta == true {
                    correct = element
                    if let btnCorrect = view.viewWithTag(index+1) as? UIButton {
                        btnCorrect.setTitleColor(UIColor(rgb: 0x86CD00), for: UIControlState())
                    }
                }
            }
            sendAnswerData(answered: answered)
            
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
        // Incorrect Question
        if self.isIncorrect {
            showIncompleteSerieDialog()
            return
        }
        if serieEnded == true {
            // Pantalla de fin de serie
            print("Fin de serie")
        } else {
            // Siguiente pregunta
            nextQuestion()
        }
    }
    
    func sendAnswerData( answered: Answer? ){
        let isPerfect = checkIsPerfect()
        //let isPerfect = 1
        if let answer = answered {
            let params: Parameters = [
                "idJugadorNivel": self.idJugadorNivel!,
                "idRespuesta": answer.idRespuesta!,
                "serie" : self.idSerie!,
                "perfecta": isPerfect,
                "idConcurso" : self.idConcurso!
            ]
            //print(params)
            ContestManager.sharedInstance.setAnswerData(params: params) { data, error in
                debugPrint(data)
                if let gamerLevel = data["jugadorNivel"].dictionary {
                    if let idJugadorNivel = gamerLevel["idJugadorNivel"]?.int,
                        let idConcurso = gamerLevel["idConcurso"]?.int,
                        let idSerie = gamerLevel["serieActual"]?.int,
                        let idNivel = gamerLevel["dNivel"]?.int {
                        
                        if (idNivel > self.idNivel!){
                            self.hasChangedLevel = true
                        }
                        self.idJugadorNivel = idJugadorNivel
                        self.idConcurso = idConcurso
                        self.idSerie = idSerie
                        self.idNivel = idNivel
                    }
                }
                return
            }
        }
    }
    
    func checkIsPerfect() -> Int{
        var perfect = 0
        if let serie = self.serie {
            //print("Score: \(score)  Questions: \(serie.questions.count)")
            perfect = (score == serie.questions.count) ? 1 : 0
        }
        return perfect
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
    
    // Next Question    
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
        classView.isHidden = true
        
        if(self.hasChangedLevel){
            showEndedLevelDialog()
        } else {
            showEndedSerieDialog()
        }
    }
    
    func showIncompleteSerieDialog(){
        let dialog = DialogController()
        dialog.message = "Ups! Fallaste en tu ultima respuesta. Deberás empezar la serie de nuevo"
        dialog.imageName = "serieIncompleta"
        dialog.delegate = self
        dialog.modalPresentationStyle = .fullScreen
        self.present(dialog, animated: true, completion: nil)
    }
    
    func showEndedSerieDialog(){
        let dialog = DialogController()
        dialog.message = "¡Terminaste la serie!"
        dialog.imageName = "serieImage"
        dialog.delegate = self
        dialog.modalPresentationStyle = .fullScreen
        self.present(dialog, animated: true, completion: nil)
    }
    
    func showEndedLevelDialog(){
        let dialog = DialogController()
        dialog.message = "¡Terminaste el nivel!"
        dialog.imageName = "nivelImage"
        dialog.delegate = self
        dialog.modalPresentationStyle = .fullScreen
        self.present(dialog, animated: true, completion: nil)
    }
    
    //MARK: - Delegate Function
    
    func dialogNextSerie(){
        if let idGamer = idJugadorNivel {
            getSerieData(id: idGamer)
            startSerie()
        }
    }
    
    func dialogGoToDashboard(){
        if(delegate != nil) {
            self.dismiss(animated: false, completion: {
                self.dismiss(animated: false, completion: {})
                self.delegate?.serieDialogCanceled()
            })
        }
    }
    
    //MARK: - Custom Function
    
    func dismissDialog(){
        if(delegate != nil) {
            self.delegate?.serieDialogCanceled()
            self.dismiss(animated: true, completion: {})
        }
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

