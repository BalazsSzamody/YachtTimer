//
//  StopwatchManager.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 08. 28..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation

protocol StopwatchManager: class {
    var stopWatch: Timer? { get set }
    var startDate: Date? { get set }
    var lapDate: Date? { get set }
    var totalTime: TimeInterval { get set }
    var lapTime: TimeInterval { get set }
    
    func startStopWatch(startedByUser: Bool)
    func stopStopWatch(_ stopWatch: Timer, stoppedByUser: Bool)
    func switchToRunningButtons()
    func switchToStartButtons()
}

extension StopwatchManager {
    func startStopWatch(startedByUser: Bool) {
        if startedByUser {
            if startDate == nil {
                startDate = Date()
            } else {
                startDate = Date().addingTimeInterval(-totalTime)
            }
            if lapDate == nil {
                lapDate = Date()
            } else {
                lapDate = Date().addingTimeInterval(-lapTime)
            }
        }
        
        
        stopWatch = Timer(timeInterval: 0.07, repeats: true) {_ in
            self.totalTime = Date().timeIntervalSince(self.startDate!)
            self.lapTime = Date().timeIntervalSince(self.lapDate!)
        }
        
        guard let stopWatch = stopWatch else { return }
        RunLoop.current.add(stopWatch, forMode: .commonModes)
    }
    
    func stopStopWatch(_ stopWatch: Timer, stoppedByUser: Bool) {
        stopWatch.invalidate()
        self.stopWatch = nil
        if !stoppedByUser {
            switchToRunningButtons()
        }
    }
}
