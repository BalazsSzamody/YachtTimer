//
//  StopwatchViewViewModel.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2018. 07. 05..
//  Copyright © 2018. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum StopwatchTimeComponentSet {
    case totalTime
    case lapTime
}

class StopwatchViewViewModel {
    
    
    
    private let timer = StopwatchTimer()
    
    let disposeBag = DisposeBag()
    
    let timerIsRunning: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    let totalHour1: Variable<String> = Variable("")
    let totalHour2: Variable<String> = Variable("")
    let totalMinute1: Variable<String> = Variable("")
    let totalMinute2: Variable<String> = Variable("")
    let totalSecond1: Variable<String> = Variable("")
    let totalSecond2: Variable<String> = Variable("")
    let totalFractionSecond1: Variable<String> = Variable("")
    let totalFractionSecond2: Variable<String> = Variable("")
    
    var totalTime: [Variable<String>]!
    
    let lapHour1: Variable<String> = Variable("")
    let lapHour2: Variable<String> = Variable("")
    let lapMinute1: Variable<String> = Variable("")
    let lapMinute2: Variable<String> = Variable("")
    let lapSecond1: Variable<String> = Variable("")
    let lapSecond2: Variable<String> = Variable("")
    let lapFractionSecond1: Variable<String> = Variable("")
    let lapFractionSecond2: Variable<String> = Variable("")
    
    var lapTime: [Variable<String>]!
    
    init() {
        totalTime = [totalHour1, totalHour2, totalMinute1, totalMinute2, totalSecond1, totalSecond2, totalFractionSecond1, totalFractionSecond2]
        lapTime = [lapHour1, lapHour2, lapMinute1, lapMinute2, lapSecond1, lapSecond2, lapFractionSecond1, lapFractionSecond2]
        bindIsRunning()
        bindTime()
    }
    
    open func startStop() {
        timer.startStop()
    }
    
    open func addLapReset() {
        timer.addLapReset()
    }
    
    
    private func bindIsRunning() {
        timer.isRunning.asObservable().subscribe(onNext: { [unowned self] isRunning in
            self.timerIsRunning.accept(isRunning)
        }).disposed(by: disposeBag)
    }
    
    private func bindTime() {
        bindTime(.totalTime, to: timer.totalTime)
        bindTime(.lapTime, to: timer.lapTime)
    }
    
    private func bindTime(_ timeComponentSet: StopwatchTimeComponentSet, to time: Variable<TimeInterval>) {
        time.asObservable().subscribe(onNext: { [unowned self] time in
            self.bind(timeComponentSet, to: time)
         }).disposed(by: disposeBag)
    }
    
    private func bind(_ timeComponentSet: StopwatchTimeComponentSet, to time: TimeInterval) {
        let timeComponents = getTimeComponents(for: timeComponentSet)
        let roundedTime = Int(time)
        let hours = roundedTime / 3600
        let minutes = (roundedTime % 3600) / 60
        let seconds = roundedTime % 60
        let fractionseconds = Int(time * 100) % 100
        
        timeComponents[0].value = hours.digits().tens.formattedString
        timeComponents[1].value = hours.digits().ones.formattedString
        timeComponents[2].value = minutes.digits().tens.formattedString
        timeComponents[3].value = minutes.digits().ones.formattedString
        timeComponents[4].value = seconds.digits().tens.formattedString
        timeComponents[5].value = seconds.digits().ones.formattedString
        timeComponents[6].value = fractionseconds.digits().tens.formattedString
        timeComponents[7].value = fractionseconds.digits().ones.formattedString
    }
    
    private func getTimeComponents(for timeComponentSet: StopwatchTimeComponentSet) -> [Variable<String>] {
        switch timeComponentSet {
        case .totalTime:
            return totalTime
        case .lapTime:
            return lapTime
        }
    }
    
    
}
