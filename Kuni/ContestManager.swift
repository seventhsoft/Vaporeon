//
//  ContestManager.swift
//  Kuni
//
//  Created by Daniel on 29/08/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ContestManager: NSObject {
    // MARK: - Constants
    
    /// The shared instance of the KuniAuth.
    static let sharedInstance: ContestManager = ContestManager()
    
    // MARK: - Initializers
    
    private override init() {
        super.init()
        
    }
    
    
    func getContestData(completionHandler: @escaping (JSON, Error?) -> ()) {
        loadContest(completionHandler: completionHandler)
    }
    
    private func loadContest(completionHandler: @escaping (JSON, Error?) -> ()) {
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.request(KuniRouter.loadConcurso)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let contest = JSON(data)
                    completionHandler(contest, nil)
                    break
                case .failure(let error):
                    if let data = response.data {
                        let json = String(data: data, encoding: String.Encoding.utf8)
                        print("Failure Response: \(json!)")
                    }
                    debugPrint(error)
                    completionHandler(false, nil)
                }
        }
    }
    
    
}
