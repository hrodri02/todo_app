//
//  Group.swift
//  productivityTracker
//
//  Created by Eri on 5/2/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import Foundation

class Group
{
    var id: String?
    var name: String = ""
    var task: [Task] = []
    var numTasksCompleted = 0 {
        didSet {
            if oldValue != numTasksCompleted {
                numTasksCompletedDidChangeClosure?()
            }
        }
    }
    var numTasksCompletedDidChangeClosure: (()->())?
    
    func fractionOfTaskCompleted() -> Float {
        if task.count == 0 {
            return 0.0
        }
        
        return Float(numTasksCompleted) / Float(task.count)
    }
}
