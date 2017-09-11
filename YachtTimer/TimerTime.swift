//
//  TimerTime.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 08. 23..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation

struct TimerTime {
    let time: Int
    

    
    var minutesString: String? {
        let minutes = time / 60
        
        return minutes > 0 ? String(format: "%02i", minutes) : nil
    }
    
    var secondsString: String {
        let seconds = time % 60
        
        return String(format: "%02i", seconds)
    }
    
    
}

struct NewTimerTime {
    let time: Int
    
    var minute1: String? {
        let minutes = time / 60
        return minutes > 0 ? "\(minutes / 10)" : nil
    }
    
    var minute2: String? {
        let minutes = time / 60
        return minutes > 0 ? "\(minutes % 10)" : nil
    }
    
    var second1: String {
        return "\(( time % 60 ) / 10)"
    }
    
    var second2: String {
        return "\((time % 60) % 10)"
    }
}
