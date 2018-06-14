//
//  TodoVC+NetworkingExtension.swift
//  productivityTracker
//
//  Created by Eri on 5/24/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension TodoVC
{
    func downloadGroups(completionHandler: @escaping ([String:Group]) -> Void) {
        guard let token = user?.authToken else {return}
        guard let uid = user?.id else {return}
        let headers: HTTPHeaders = ["x-auth-token": token, "_id": uid]
        
        guard let groupsDate = date else {return}

        let todayString = groupsDate.getYear() + "-" + groupsDate.getMonth() + "-" + groupsDate.getDay()
        let groupsDateURL = Routes.groupsURL + "/" + todayString
        
        Alamofire.request(groupsDateURL, method: .get, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var groupDict: [String:Group] = [:]
                
                if let groupsArr = json.array {
                    for groupObj in groupsArr {
                        let newGroup = Group()
                        
                        newGroup.id = groupObj["_id"].stringValue
                        newGroup.name = groupObj["name"].stringValue
                        if let groupId = newGroup.id {
                            groupDict[groupId] = newGroup
                        }
                        
                        if let taskArray =  groupObj["tasks"].array
                        {
                            
                            for taskObj in taskArray {
                                let newTask = Task()
                                newTask.id = taskObj["_id"].stringValue
                                newTask.name = taskObj["name"].stringValue
                                newTask.isComplete = taskObj["isComplete"].boolValue
                                newTask.totalSeconds = taskObj["totalSeconds"].intValue
                                
                                newGroup.task.append( newTask )
                            }
                        }
                    }
                }
                
                completionHandler( groupDict )
            case .failure(let error):
                print(error)
                debugPrint(response)
            }
        }
    }
    
    func initGroups(_ groupDict: [String:Group]) {
        
        groupsDict = groupDict
        group = Array(groupsDict.values)
        
        group.sort(by: { (group1, group2) -> Bool in
            return group1.name < group2.name
        })
        
        for element in group {
            element.task.sort(by: { (task1, task2) -> Bool in
                return task1.name < task2.name
            })
        }
        
        groupsTableView.reloadData()
    }
    
    func postGroup(_ group: Group, completionHandler: @escaping (String, Group) -> Void) {
        guard let token = user?.authToken else {return}
        guard let uid = user?.id else {return}
        let params = ["name": group.name, "_id": uid]
        let headers: HTTPHeaders = ["x-auth-token": token]
        
        Alamofire.request(Routes.groupsURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                guard let groupDict = json.dictionary else {return}
                guard let groupId = groupDict["_id"]?.stringValue else {return}
                completionHandler(groupId, group)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func saveGroupInDict(_ groupId: String, _ newGroup: Group) {
        group[group.endIndex - 1].id = groupId
        groupsDict[groupId] = newGroup
    }
    
    func putGroup(_ groupId: String) {
        let groupURL = Routes.groupsURL + "/" + groupId
        
        guard let token = user?.authToken else {return}
        let headers: HTTPHeaders = ["x-auth-token": token]
        guard let groupName = groupsDict[groupId]?.name else {return}
        let params = ["name": groupName]
        
        Alamofire.request(groupURL, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func deleteGroup(_ groupId: String) {
        let groupURL =  Routes.groupsURL + "/" + groupId
        
        guard let token = user?.authToken else {return}
        let headers: HTTPHeaders = ["x-auth-token": token]
        
        Alamofire.request(groupURL, method: .delete, headers: headers).responseJSON { (response) in
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
