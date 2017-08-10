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
    case closeSession(parameters: Parameters)
    case lostPassword(parameters: Parameters)

    static let baseURLString = "http://api.juegakuni.com.mx/lfs"    

    var method: HTTPMethod {
        switch self {
        case .loginUser:
            return .post
        case .registerUser:
            return .post
        case .closeSession:
            return .post
        case .lostPassword:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .loginUser:
            return "/oauth/token"
        case .registerUser:
            return "/usuarios"
        case .closeSession(let token):
            return "/tokens/revokeRefreshToken/\(token)"
        case .lostPassword:
            return "/usuarios/recuperar/password"
        }
    }
    
    var headers: HTTPHeaders {
        var hcontainer:HTTPHeaders = [:]
        switch self {
        case .loginUser:
            hcontainer = [ "Authorization": "Basic bW9iaWxlQ2xpZW50OnNlY3JldE1vYmlsZQ==",
                           "Content-type": "application/x-www-form-urlencoded"]
        case .registerUser,
             .lostPassword:
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
            case .loginUser:
                return URLEncoding.default
            case .registerUser,
                 .lostPassword:
                return JSONEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        switch self {
        case .loginUser(let parameters),
             .registerUser(let parameters),
             .lostPassword(let parameters),
             .closeSession(let parameters):
            urlRequest = try encoding.encode(urlRequest, with: parameters)
        default:
            break
        }
        
        return urlRequest
    
    }

}
