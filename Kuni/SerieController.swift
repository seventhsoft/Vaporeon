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
        rect.backgroundColor = Color.questionBackground.value
        rect.layer.cornerRadius = 8
        rect.addShadow(offset: CGSize(width: -1, height: 1), color: UIColor.black, radius: 3, opacity: 0.5)
        rect.translatesAutoresizingMaskIntoConstraints = false
        return rect
    }()

    
    private lazy var backgroundClass: UIView = {
        let rect = UIView()
        rect.backgroundColor = Color.classBackground.value
        rect.layer.cornerRadius = 8
        rect.addShadow(offset: CGSize(width: -1, height: 1), color: UIColor.black, radius: 3, opacity: 0.5)
        rect.translatesAutoresizingMaskIntoConstraints = false
        return rect
    }()
    
    private lazy var classView: UIView = {
        let itemView = UIView()
        itemView.backgroundColor = Color.mainDialogBackground.value
        return itemView
    }()
    
    // MARK: - Labels and buttons for Question view
    
    lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Font(.custom("SFProDisplay-Heavy"), size: .custom(24.0)).instance
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()

    lazy var questionLevelSerieLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Font(.custom("SFProDisplay-Heavy"), size: .custom(13.0)).instance
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var questionNumberLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Font(.custom("SFProDisplay-Regular"), size: .custom(13.0)).instance
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var questionCounter: EFCountingLabel = {
        let label = EFCountingLabel()
        label.numberOfLines = 0
        label.font = Font(.custom("SFProDisplay-Heavy"), size: .custom(30.0)).instance
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
        button.setTitleColor(Color.answerNormal.value, for: UIControlState())
        button.titleLabel?.font = Font(.custom("SFProDisplay-Regular"), size: .custom(18.0)).instance
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
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
        button.setTitleColor(Color.answerNormal.value, for: UIControlState())
        button.titleLabel?.font = Font(.custom("SFProDisplay-Regular"), size: .custom(18.0)).instance
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
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
        button.setTitleColor(Color.answerNormal.value,  for: UIControlState())
        button.titleLabel?.font = Font(.custom("SFProDisplay-Regular"), size: .custom(18.0)).instance
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(selectAnswer(_:)), for: .touchUpInside)
        button.tag = 3
        return button
    }()
    
    // MARK: - Labels and buttons for Class View
    lazy var responseLeyend: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Font(.custom("SFProDisplay-Heavy"), size: .custom(14.0)).instance
        label.textColor = .white
        label.textAlignment = .left
        label.text = "Respuesta correcta:"
        return label
    }()
    
    lazy var responseDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Font(.custom("SFProDisplay-Heavy"), size: .custom(24.0)).instance
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var classDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Font(.custom("SFProDisplay-Regular"), size: .custom(18.0)).instance
        label.textColor = Color.textColor.value
        label.textAlignment = .center
        return label
    }()
    
    lazy var nextQuestionButton: KuniButton = {
        let button = KuniButton()
        button.backgroundColor = Color.classNextQuestion.value
        button.setTitleColor(.white, for: UIControlState())
        button.setTitle("Siguiente", for: UIControlState())
        button.addTarget(self, action: #selector(sendButtonClassFeedback(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Transparent Navigation Bar
        let navBar = self.navigationController?.navigationBar
        navBar?.tintColor = Color.mainTintColor.value
        navBar?.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightHeavy),
            NSForegroundColorAttributeName : Color.titleColor.value
        ]
        navBar?.barTintColor = .white
        navBar?.backgroundColor = .white
        navBar?.shadowImage = UIImage()
        navBar?.isTranslucent = false
        
        let btnCancel = UIBarButtonItem(title: "Abandonar", style: .done, target: self, action: #selector(dismissDialog))
        self.navigationItem.leftBarButtonItem = btnCancel
        
        view.backgroundColor = Color.mainDialogBackground.value
        self.title = "KUNI"
        
        if let idGamer = idJugadorNivel {
            getSerieData(id: idGamer)
        }
        
    }

    func getSerieData(id: Int){
        let params: Parameters = [ "idJugadorNivel": id ]
        ContestManager.sharedInstance.getSerieData(params: params){ data, error in
            if data.count > 0 {
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
                        //let banner = question["bannerPregunta"].string,
                        let activo = question["activo"].bool,
                        let respuestas = question["respuestaList"].array {
                            questionItem.idPregunta = idPregunta
                            questionItem.descripcion = descripcion
                            questionItem.ruta = ruta
                            questionItem.clase = clase
                            //questionItem.banner = banner
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
        scrollView.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20)
        
        roundRect.addSubview(cardQuestion)
        scrollView.addSubview(roundRect)
        scrollView.addSubview(buttons)
        
        roundRect.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        roundRect.heightAnchor.constraint(equalTo: cardQuestion.heightAnchor, constant: 0).isActive = true
        roundRect.anchorWithConstantsToTop(scrollView.topAnchor, left: scrollView.leftAnchor, bottom: buttons.topAnchor, right: scrollView.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 40, rightConstant: 0)
        
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
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 30, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        
        backgroundClass.addSubview(container)
        
        let main = getStackView(orientation: .vertical, spacing: 10)
        main.addArrangedSubview(backgroundClass)
        main.addArrangedSubview(classDescription)
        main.addArrangedSubview(nextQuestionButton)
        main.translatesAutoresizingMaskIntoConstraints = false
        
        classView.addSubview(main)
        
        //Constraints
        main.anchorWithConstantsToTop(classView.topAnchor, left: classView.leftAnchor, bottom: classView.bottomAnchor, right: classView.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 30, rightConstant: 20)
        
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
            answer1.titleLabel?.font = Font(.custom("SFProDisplay-Regular"), size: .custom(18.0)).instance
            answer2.setTitle(selectedQuestion.respuestas[1].descripcion, for: UIControlState())
            answer2.titleLabel?.font = Font(.custom("SFProDisplay-Regular"), size: .custom(18.0)).instance
            answer3.setTitle(selectedQuestion.respuestas[2].descripcion, for: UIControlState())
            answer3.titleLabel?.font = Font(.custom("SFProDisplay-Regular"), size: .custom(18.0)).instance
            if let idNivel = self.idNivel,
                let idSerie = self.idSerie {
                questionLevelSerieLabel.text = "Nivel \(idNivel)/ Serie \(idSerie)"
                questionNumberLabel.text = "Pregunta \(questionId + 1)"
            }
            if let timeInterval = serieItem.tiempo {
                // Start question counter
                questionCounter.countFrom(CGFloat(timeInterval), to: 0, withDuration: Double(timeInterval))
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
        answer1.setTitleColor(Color.answerNormal.value,  for: UIControlState())
        answer2.isEnabled = true
        answer2.setTitleColor(Color.answerNormal.value,  for: UIControlState())
        answer3.isEnabled = true
        answer3.setTitleColor(Color.answerNormal.value,  for: UIControlState())
    }
    
    func checkAnswer(timerHasFinished: Bool){
        disableButtons()
        if timerHasFinished {            
            let correct = highlightCorrectAnswer(correctInBold: true)
            delayWithSeconds(2) {
                self.isIncorrect = true
                self.setClassFeedback(correct!, correct: correct)
            }
            
        }
    }
    
    func highlightCorrectAnswer(correctInBold: Bool) -> Answer? {
        var correct:Answer?
        if let serieItem = self.serie {
            let answers = serieItem.questions[currentQuestion].respuestas
            for (index,element) in answers.enumerated() {
                if element.correcta == true {
                    correct = element
                    if let btnCorrect = view.viewWithTag(index+1) as? UIButton {
                        btnCorrect.setTitleColor(Color.answerCorrect.value, for: UIControlState())
                        if correctInBold {
                            btnCorrect.titleLabel?.font = Font(.custom("SFProDisplay-Heavy"), size: .custom(18.0)).instance
                        }
                    }
                }
            }
        }
        return correct
    }
    
    func selectAnswer(_ sender:UIButton){
        let answerId = sender.tag - 1
        questionCounter.stopCount()
        disableButtons()
        if let serieItem = self.serie {
            let answered = serieItem.questions[currentQuestion].respuestas[answerId]
            sender.setTitleColor(Color.answerFail.value, for: UIControlState())
            sender.titleLabel?.font = Font(.custom("SFProDisplay-Heavy"), size: .custom(18.0)).instance
            if (answered.correcta == true) {
                self.score += 1
                sender.setTitleColor(Color.answerCorrect.value, for: UIControlState())
                self.isIncorrect = false
            } else {
                self.isIncorrect = true
            }

            let correct = highlightCorrectAnswer(correctInBold: false)
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
                // Draw standar Class Image
                if let classImage = UIImage(named: "defaultClassImage") {
                    drawImageInClassContainer(image: classImage )
                }
                self.getClassImage() { image, error in
                    if (error == false) {
                        self.drawImageInClassContainer(image: image)
                    }
                    return
                }
            }
            classView.isHidden = false
        }
    }
    
    func drawImageInClassContainer(image: UIImage){
        UIGraphicsBeginImageContext(self.backgroundClass.frame.size)
        image.draw(in: self.backgroundClass.bounds)
        if let bgImage: UIImage = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.backgroundClass.backgroundColor = UIColor(patternImage: bgImage)
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
            
            ContestManager.sharedInstance.setAnswerData(params: params) { data, error in
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
    
    //MARK: - Delegate Functions
    
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
    
    //MARK: - Custom Functions
    
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

