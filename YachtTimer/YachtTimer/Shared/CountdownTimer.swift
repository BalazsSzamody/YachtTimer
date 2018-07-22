//
//  CountdownTimer.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2018. 07. 22..
//  Copyright © 2018. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CountdownTimer {
    
    let countdown: Variable<Int> = Variable(0)
    
    let isRunning: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    let isFinished: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    public func startStop() {
        
    }
    
    public func resetSync() {
        
    }
    
    public func addMinute() {
        
    }
    
    public func subtractMinute() {
        
    }
}
