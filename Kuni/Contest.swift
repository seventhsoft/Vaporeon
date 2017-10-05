//
//  Level.swift
//  Kuni
//
//  Created by Daniel on 18/08/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import Foundation

// MARK: - Contest Models

class Level {
    var name: String?
    var number: Int?
    var series: Int?
    var seriesJugador: Int?
    var tieneRecompensa: Bool?
    var recompensasDisponibles: Int?
    var isActive: Bool?
    var isEnabled: Bool?
}

class ContestData {
    var idConcurso: Int?
    var fechaInicio: Int?
    var fechaFin: Int?
    var activo: Bool?
}

class GamerLevel {
    var idJugadorNivel: Int?
    var serieActual: Int?
    var dNivel: Int?
}

// MARK: - Game models

class Serie {
    var tiempo: Int?
    var questions = [Question]()
    var banner: String?
}

class Question {
    var idPregunta: Int?
    var descripcion: String?
    var ruta: String?
    var clase: String?
    var banner: String?
    var activo: Bool?
    var respuestas = [Answer]()
}

class Answer {
    var idRespuesta: Int?
    var descripcion: String?
    var orden: Int?
    var correcta: Bool?
    var activo:Bool?
}
