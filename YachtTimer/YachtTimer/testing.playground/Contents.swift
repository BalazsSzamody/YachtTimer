//: Playground - noun: a place where people can play

import UIKit

struct TimerTime {
    let time: TimeInterval
    
    var minutesString: String? {
        let minutes = time / 60
        print("Minutes:", minutes)
        
        return minutes > 0 ? String(format: "%02i", Int(minutes)) : nil
    }
    
    var secondsString: String {
        let seconds = time.truncatingRemainder(dividingBy: 60)
        
        return String(format: "%02i", Int(seconds))
    }
}

let time = TimerTime(time: 150)
print(time.time)
print(time.minutesString ?? "00", ":", time.secondsString)