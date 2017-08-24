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
