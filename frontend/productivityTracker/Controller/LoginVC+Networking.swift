//
//  LoginVC+Networking.swift
//  productivityTracker
//
//  Created by Eri on 5/29/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension LoginVC
{
    func registerUserInDB(_ user: User, password: String, completionHandler: @escaping (String, String?) -> Void) {
        let params = ["name": user.name, "email": user.email, "password": password]
        
        Alamofire.request(Routes.usersURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let authToken = response.response?.allHeaderFields["x-auth-token"] as? String
                let userId = json["_id"].stringValue
                
                completionHandler(userId, authToken)
            case .failure(let err):
                print(err)
                debugPrint(response)
            }
        }
    }
    
    func authUser(_ user: User, password: String, completionHandler: @escaping (String?) -> Void) {
        let params = ["email": user.email, "password": password]
        Alamofire.request(Routes.authURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseString {
            response in
            switch response.result {
                
            case .success(let authToken):
                completionHandler(authToken)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func siginWithToken(_ name: String, token: String, completionHandler: @escaping (String?, NSError?) -> Void) {
        let params = ["name": name]
        let headers: HTTPHeaders = ["x-auth-token": token]
        
        Alamofire.request(Routes.tokenSignInURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
            
                switch response.result {
                    
                case .success(let value):
                    let json = JSON(value)
                    
                    let userId = json["_id"].stringValue
                    completionHandler(userId, nil)
                case .failure(_:):
                    self.createAlert(title: "Error", msg: "Failed to login.")
                    debugPrint(response)
                }
            }
            .responseString { (response) in
//                guard let statusCode = response.response?.statusCode else {return}
//                guard let value = response.result.value else {return}
//
//                let userInfo: [String : Any] = [NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: value, comment: "")]
//                let error = NSError(domain: "", code: statusCode, userInfo: userInfo)
//
//                completionHandler(nil, error)
            }
    }
}

