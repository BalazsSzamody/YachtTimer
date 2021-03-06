//
//  StopWatch.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 07. 13..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation

struct LapTime: CustomStringConvertible {
    
    let totalTime: TimeInterval
    let previousLap: TimeInterval
    
    var lapTime: TimeInterval {
        return totalTime - previousLap
    }
    
    let lapNumber: Int
    
    var description: String {
        return "totalTime: \(totalTime), previousLap: \(previousLap), lapTime: \(lapTime), lapNumber: \(lapNumber)"
    }
    
    static var laps: [LapTime] = []
    
    static func addLap(_ time: TimeInterval) {
        guard !laps.isEmpty else {
            laps.insert(LapTime(totalTime: time, previousLap: 0, lapNumber: laps.count + 1), at: 0)
            return
        }
        let lastTotal = laps[0].totalTime
        laps.insert(LapTime(totalTime: time, previousLap: lastTotal, lapNumber: laps.count + 1), at: 0)
        
    }
    
}
