//
//  GroupVC+Networking.swift
//  productivityTracker
//
//  Created by Eri on 5/24/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension GroupVC {
    func postTask(_ groupId: String, _  task: Task, completionHandler: @escaping (String) -> Void) {
        let groupURL = Routes.groupsURL + "/" + groupId
        
        guard let token = user?.authToken else {return}
        let headers: HTTPHeaders = ["x-auth-token": token]
        
        let params = ["name": task.name]
        
        Alamofire.request(groupURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                let taskId = json["_id"].stringValue
                completionHandler( taskId )
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func setIdOfTask(_ taskId: String) {
        guard var indexOfLast = group?.task.endIndex else {return}
        indexOfLast -= 1
        group?.task[indexOfLast].id = taskId
    }
    
    func putTask(_ groupId: String, _ task: Task) {
        guard let taskId = task.id else {return}
        let taskURL = Routes.groupsURL + "/" + groupId + "/" + taskId
        
        guard let token = user?.authToken else {return}
        let headers: HTTPHeaders = ["x-auth-token": token]
    
        let params = ["name": task.name, "isComplete": task.isComplete, "totalSeconds": task.totalSeconds] as [String : Any]
    
        Alamofire.request(taskURL, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func deleteTask(_ groupId: String, _ taskId: String) {
        let taskURL =  Routes.groupsURL + "/" + groupId + "/" + taskId
        
        guard let token = user?.authToken else {return}
        let headers: HTTPHeaders = ["x-auth-token": token]
        
        Alamofire.request(taskURL, method: .delete, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let err):
                print(err)
                debugPrint(response)
            }
        }
    }
}
