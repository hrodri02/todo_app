//
//  GroupTVCell+UITextFieldDelegate.swift
//  productivityTracker
//
//  Created by Eri on 6/11/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import Foundation

extension GroupTVCell {
    @objc func startStopButtonTapped() {
        guard let seconds = task?.seconds else {return}
        guard let isTimerRunning = task?.isTimerRunning else {return}
        guard var startStopTapped = task?.startStopTapped else {return}
        
        if isTimerRunning {
            if !startStopTapped {
                task?.timer.invalidate()
                startStopTapped = true
                task?.startStopTapped = startStopTapped
                startStopButton.setTitle("Start", for: .normal)
            }
            else {
                runTimer()
                startStopTapped = false
                task?.startStopTapped = startStopTapped
                startStopButton.setTitle("Stop", for: .normal)
            }
        }
        else
        {
            if seconds > 0 {
                runTimer()
                startStopTapped = false
                task?.startStopTapped = startStopTapped
                startStopButton.setTitle("Stop", for: .normal)
            }
            else {
                if audioPlayer.isPlaying
                {
                    audioPlayer.stop()
                    audioPlayer.currentTime = 0
                }
                startStopButton.isEnabled = false
            }
        }
    }
    
    @objc func resetButtonTapped() {
        task?.timer.invalidate()
        task?.isTimerRunning = false
        
        guard let secondsSelected = task?.secondsSelected else {return}
        guard let seconds = task?.seconds else {return}
        
        task?.totalSeconds += secondsSelected - seconds
        task?.seconds = secondsSelected
        
        setTextFields(time: TimeInterval(secondsSelected))
        secsTextField.isUserInteractionEnabled = true
        
        startStopButton.setTitle("Start", for: .normal)
        startStopButton.isEnabled = true
        
        if audioPlayer.isPlaying {
            audioPlayer.stop()
            audioPlayer.currentTime = 0
        }
        
        // update time spent on task in db
        // Note: user might not let the time go down to 0 so it is better to save the time here
        updateTaskInDB()
    }
    
    func runTimer() {
        task?.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        task?.isTimerRunning = true
        
        secsTextField.isUserInteractionEnabled = false
        
        resetButton.isEnabled = true
    }
    
    @objc func updateTimer()
    {
        guard var seconds = task?.seconds else {return}
        if seconds < 1 {
            task?.timer.invalidate()
            
            // alert user that time is up
            startStopButton.setTitle("OK", for: .normal)
            audioPlayer.play()
            task?.isTimerRunning = false
        }
        else {
            seconds -= 1
            task?.seconds = seconds
            setTextFields(time: TimeInterval(seconds))
        }
    }
}
