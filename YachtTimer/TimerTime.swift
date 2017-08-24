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
