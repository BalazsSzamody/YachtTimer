//
//  StopwatchTimer.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2018. 07. 22..
//  Copyright © 2018. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class StopwatchTimer {
    
    let isRunning: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    let totalTime: Variable<TimeInterval> = Variable(0)
    let lapTime: Variable<TimeInterval> = Variable(0)
    
    public func startStop() {
        
    }
    
    public func addLapReset() {
        
    }
}
