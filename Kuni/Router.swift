//
//  Router.swift
//  Kuni
//
//  Created by Daniel on 30/07/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import Foundation
import Alamofire

enum KuniRouter: URLRequestConvertible {
    case loginUser(parameters: Parameters)
    case registerUser(parameters: Parameters)
    case refreshToken(parameters: Parameters)
    case closeSession(parameters: Parameters)
    case lostPassword(parameters: Parameters)
    case getProfile
    case setProfile(parameters: Parameters)
    case loadConcurso
    case loadSerie(parameters: Parameters)

    static let baseURLString = "http://qa.api.juegakuni.com.mx/lfs"    

    var method: HTTPMethod {
        switch self {
        case .loginUser, .registerUser, .refreshToken, .closeSession, .lostPassword:
            return .post
        case .getProfile, .loadConcurso, .loadSerie:
            return .get
        case .setProfile:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .loginUser:
            return "/oauth/token"
        case .registerUser:
            return "/usuarios"
        case .refreshToken(let token):
            return "/tokens/revokeRefreshToken/\(token)"
        case .closeSession(let token):
            return "/oauth/token/revokeById/\(token)"
        case .lostPassword:
            return "/usuarios/recuperar/password"
        case .getProfile:
            return "/usuarios/perfil"
        case .setProfile:
            return "/usuarios"
        case .loadConcurso:
            return "/jugador/concurso"
        case .loadSerie:
            return "/concurso/serie"
        }
        
    }
    
    var headers: HTTPHeaders {
        var hcontainer:HTTPHeaders = [:]
        switch self {
        case .loginUser:
            hcontainer = [ "Authorization": "Basic bW9iaWxlQ2xpZW50OnNlY3JldE1vYmlsZQ==",
                           "Content-type": "application/x-www-form-urlencoded"]
        case .registerUser, .lostPassword, .getProfile, .setProfile, .loadConcurso:
            hcontainer = [ "Content-type": "application/json; charset=utf-8" ]
        default:
            hcontainer = [ "Content-type": "application/x-www-form-urlencoded" ]
        }
        return hcontainer
    }


    
    func asURLRequest() throws -> URLRequest {
        let url = try KuniRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers

        let encoding: ParameterEncoding = {
            switch self {
            case .loginUser, .loadSerie:
                return URLEncoding.default
            case .registerUser, .lostPassword, .getProfile, .setProfile, .loadConcurso:
                return JSONEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        switch self {
        case .loginUser(let parameters),
             .registerUser(let parameters),
             .lostPassword(let parameters),
             .setProfile(let parameters),
             .loadSerie(let parameters),
             .refreshToken(let parameters),
             .closeSession(let parameters):
            urlRequest = try encoding.encode(urlRequest, with: parameters)
        default:
            break
        }
        
        return urlRequest
    
    }    
}
