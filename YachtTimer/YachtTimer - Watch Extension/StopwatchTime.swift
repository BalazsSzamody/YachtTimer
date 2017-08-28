//
//  StopwatchTime.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 08. 15..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation

struct StopwatchTime {
    
    let time: TimeInterval
    
    var counter: Int {
        return Int(time * 100)
    }
    
    var hoursString: String? {
        let hours = counter / 360000
        
        return hours > 0 ? String(format: "%02i", hours) : nil
    }
    
    var minutesString: String? {
        let minutes = ( counter % 360000) / 6000
        
        return minutes > 0 || hoursString != nil ? String(format: "%02i", minutes) : nil
    }
    
    var secondsString: String {
        let seconds = ( counter % 6000 ) / 100
        
        return String(format: "%02i", seconds)
    }
    
    var fractionSecondsString: String {
        let fractionSeconds = counter % 100
        
        return String(format: "%02i", fractionSeconds)
    }
}

struct NewStopwatchTime: CustomStringConvertible {
    let time: TimeInterval
    
    var counter: Int {
        return Int(time * 100)
    }
    
    var hours: Int {
        return counter / 360000
    }
    
    var hourFirst: String? {
        let number = hours / 10
        
        return number > 0 || ( hours % 10) > 0 ? "\(number)" : nil
    }
    
    var hourSecond: String? {
        let number = ( counter / 360000 ) % 10
        
        return number > 0 || ( hours / 10 ) > 0 ? "\(number)" : nil
    }
    
    var minutes: Int {
        return ( counter % 360000 ) / 6000
    }
    
    var minuteFirst: String? {
        let number = minutes / 10
        
        return number > 0 || ( minutes % 10 ) > 0 ? "\(number)" : nil
    }
    
    var minuteSecond: String? {
        let number = minutes % 10
        
        return number > 0 || (minutes / 10) > 0 ? "\(number)" : nil
    }
    
    var seconds: Int {
        return ( counter % 6000) / 100
    }
    
    var secondFirst: String {
        return "\(seconds / 10)"
    }
    
    var secondSecond: String {
        return "\(seconds % 10)"
    }
    
    var fractionSeconds: Int {
        return counter % 100
    }
    
    var fractionSecondFirst: String {
        return "\(fractionSeconds / 10)"
    }
    
    var fractionSecondSecond: String {
        return "\(fractionSeconds % 10)"
    }
    
    var description: String {
        return "\(hourFirst ?? "")\(hourSecond ?? ""):\(minuteFirst ?? "")\(minuteSecond ?? ""):\(secondFirst)\(secondSecond).\(fractionSecondFirst)\(fractionSecondSecond)"
    }
}
