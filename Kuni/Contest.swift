//
//  Level.swift
//  Kuni
//
//  Created by Daniel on 18/08/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import Foundation

class Level {
    var name: String?
    var number: Int?
    var series: Int?
    var seriesJugador: Int?
    var tieneRecompensa: Bool?
    var recompensasDisponibles: Int?
    var isActive: Bool?
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
