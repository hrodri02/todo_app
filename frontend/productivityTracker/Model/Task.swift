//
//  Task.swift
//  productivityTracker
//
//  Created by Eri on 5/8/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import Foundation
import AVFoundation

class Task
{
    var id: String?
    var name = ""
    var isComplete = false
    
    var seconds = 0
    var secondsSelected = 0
    var totalSeconds = 0

    var timer = Timer()
    var isTimerRunning = false
    var startStopTapped = false
}
