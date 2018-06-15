//
//  DayVC+Networking.swift
//  productivityTracker
//
//  Created by Eri on 6/7/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension DayVC {
    func getDays(completionHandler: @escaping ([String:Day]) -> Void) {
        guard let token = user?.authToken else {return}
        guard let uid = user?.id else {return}
        let headers: HTTPHeaders = ["x-auth-token": token, "_id": uid]
        
        Alamofire.request(Routes.groupsURL, method: .get, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                if let daysArr = json.array {
                    var days = [String:Day]()
                    
                    for dayObj in daysArr {
                        let groupId = dayObj["_id"].stringValue
                        let day = dayObj["date"].stringValue
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                        
                        guard let date = dateFormatter.date(from: day) else {
                            fatalError("ERROR: Date conversion failed due to mismatched format")
                        }
                        
                        let dateStr = date.getYear() + "-" + date.getMonth() + "-" + date.getDay()
                        
                        if days[dateStr] != nil {
                            days[dateStr]?.groupIds.append(groupId)
                        }
                        else {
                            let newDay = Day()
                            newDay.date = date
                            newDay.groupIds.append(groupId)
                            days[dateStr] = newDay
                        }
                    }
                    
                    completionHandler(days)
                }
            case .failure(let error):
                print(error)
                debugPrint(response)
            }
        }
    }
    
    func initDates(_ dates: [String:Day]) {
        let dayArr = Array(dates.values)
        
        for i in 0 ..< dayArr.count {
            if let date = dayArr[i].date {
                if date.isOld() {
                    days.append(dayArr[i])
                }
            }
        }
        
        days.sort(by: { (day1, day2) -> Bool in
            return day1.date! < day2.date!
        })
        
        daysTableView.reloadData()
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
