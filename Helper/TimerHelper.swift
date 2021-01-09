//
//  TimerHelper.swift
//  Puzly
//
//  Created by John on 14/12/2020.
//

import Foundation

protocol TimerHelperDelegate {

    func didUpdateTimer(counter: Double)
}

class TimerHelper {
    
    var delegate: TimerHelperDelegate?
    var timer = Timer()
    var timePassed: String = ""
    var timePassedMinutes: String = ""
    var timePassedSeconds: String = ""
    
    var counter: Double = 0
    
    enum TimeType {
        
        case normal, withText
    }
    
    func startTimer() {
        
        counter = 0
        timePassedMinutes = ""
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        
        timer.invalidate()
    }
    
    @objc func UpdateTimer() {
        counter = counter + 0.1
        delegate?.didUpdateTimer(counter:counter)
    }
    
    func getTimePassed (counter : Double, type: TimeType) -> String {
        
        let tenths = Int((counter.truncatingRemainder(dividingBy: 1)) * 10)
        let seconds = (Int(counter) % 3600) % 60
        let minutes = (Int(counter) % 3600) / 60
        
        switch type {
        
        case .normal:
            
            timePassed = String(format: "%0.2d:%0.2d.%0.2d",minutes,seconds,tenths)
            
        case .withText:
            
            if minutes != 0 {
                
                timePassedMinutes = String(format: "%2d minute".makePlural(minutes),minutes)
            }
            
            timePassedSeconds = String(format: "%2d.%0.2d seconds",seconds,tenths)
            timePassed = timePassedMinutes + timePassedSeconds
            
        }
        
        return timePassed
    }
}

