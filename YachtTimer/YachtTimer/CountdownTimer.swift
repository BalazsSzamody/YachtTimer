//
//  StopWatch.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 07. 13..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation

class CountdownTimer {
    
    var isTimerRunning = false
    
    var counter: Int {
        didSet{
            
            if counter == 0 {
                timer?.invalidate()
                isTimerRunning = false
            }
        }
    }
    
    var minutes: Int {
        
        return counter / 60
        
    }
    
    var seconds: Int {
        
        return counter % 60
    }
    
    var timer: Timer?
    
    init(){
        counter = 0
        timer = nil
    }
    
    init(counter: Int) {
        self.counter = counter
        timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(CountdownTimer.updateCounter)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    @objc func updateCounter() {
        counter -= 1
    }
}
