//
//  CountdownViewViewModel.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2018. 07. 04..
//  Copyright © 2018. Szamódy Zs. Balázs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class CountdownViewViewModel {
    
    let timer = CountdownTimer()
    
    let minute: Variable<String> = Variable("")
    
    let second: Variable<String> = Variable("")
    
    let labelColor: Variable<UIColor> = Variable(InterfaceColor.defaultColor)
    
    let timerIsRunning: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    let timerIsFinished: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    let alert = TextToSpeech()
    
    let disposeBag = DisposeBag()
    
    
    
    let green = InterfaceColor.brightGreen
    let yellow = InterfaceColor.brightYellow
    let red = InterfaceColor.brightRed
    let blue = InterfaceColor.blue
    let lightBlue = InterfaceColor.lightBlue
    let white = InterfaceColor.white
    let transparent = InterfaceColor.transparent
    
    init() {
        bindMinute()
        bindSecond()
        bindInterfaceColor()
        bindIsRunning()
        bindIsFinished()
    }
    
    open func startStop() {
        timer.startStop()
    }
    
    open func resetSync() {
        timer.resetSync()
    }
    
    open func addMinute() {
        timer.addMinute()
    }
    
    open func subtractMinute() {
        timer.subtractMinute()
    }
    
    private func bindMinute() {
        timer.countdown.asObservable().subscribe(onNext: { [unowned self] countdown in
            let minutes = countdown / 60
            self.minute.value = String(format: "%02i", minutes)
        }).disposed(by: disposeBag)
    }
    
    private func bindSecond() {
        timer.countdown.asObservable().subscribe(onNext: { [unowned self] countdown in
            let seconds = countdown % 60
            self.second.value = String(format: "%02i", seconds)
        }).disposed(by: disposeBag)
    }
    
    private func bindIsRunning() {
        timer.isRunning.asObservable().subscribe(onNext: { [unowned self] isRunning in
            self.timerIsRunning.accept(isRunning)
        }).disposed(by: disposeBag)
    }
    
    private func bindIsFinished() {
        timer.isFinished.asObservable().subscribe(onNext: { [unowned self] isFinished in
            self.timerIsFinished.accept(isFinished)
        }).disposed(by: disposeBag)
    }
    
    private func bindInterfaceColor() {
        timer.countdown.asObservable().subscribe(onNext: { [unowned self] countdown in
            let isWithinTwoMinutes = countdown < 120
            let isWithinAMinute = countdown < 60
            
            if isWithinAMinute {
                self.labelColor.value = InterfaceColor.withinOneMinuteColor
            } else if isWithinTwoMinutes {
                self.labelColor.value = InterfaceColor.withinTwoMinutesColor
            } else {
                self.labelColor.value = InterfaceColor.defaultColor
            }
        }).disposed(by: disposeBag)
    }
    
    private func bindAlert() {
        timer.countdown.asObservable().subscribe(onNext: { [unowned self] countdown in
            let isWholeMinute = countdown % 60 == 0
            let isHalfMinuteWithinTwoMinutes = countdown < 120 && countdown % 30 == 0
            let isQuarterMinuteWithinAMinute = countdown < 60 && countdown % 15 == 0
            let isDivbleByFiveWithinHalfMinute = countdown < 30 && countdown % 5 == 0
            let isWithinQuarterMinute = countdown < 15
            let isStart = countdown == 0
            
            if isWholeMinute || isHalfMinuteWithinTwoMinutes || isQuarterMinuteWithinAMinute || isDivbleByFiveWithinHalfMinute || isWithinQuarterMinute || isStart {
                self.alert.sayOutLoud(countdown)
            }
        }).disposed(by: disposeBag)
    }
}
