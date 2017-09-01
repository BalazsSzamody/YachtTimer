//
//  WatchTimerTimeDisplay.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 08. 23..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation
import WatchKit

protocol WatchTimerTimeDisplay {
    var collection: WatchLabelCollection? { get set }
    var currentScreenSize: ScreenSize? { get set }
    
    func updateDisplay(_ timeInterval: Int, for collection: LabelCollection?)
    
    func manageLabelColors(_ time: Int)
}

extension WatchTimerTimeDisplay {
    func updateDisplay(_ timeInterval: Int, for collection: LabelCollection?) {
        guard let collection = collection as? WatchLabelCollection else { return }
        let labels = collection.labels
        let time = TimerTime(time: timeInterval)
        let multiplier = determineScale(time, for: collection)
        let fontSize = 63 * multiplier
        let labelWidth = 71 * multiplier
        let labelHeight = 47 * multiplier
        
        if let minutesString = time.minutesString {
            labels[0].setHidden(false)
            labels[1].setHidden(false)
            labels[0].setAttributedText(setText(minutesString, for: fontSize))
            labels[0].setWidth(labelWidth)
            labels[0].setHeight(labelHeight)
            labels[1].setAttributedText(setText(":", for: 30))
            labels[1].setHeight(labelHeight)
        } else {
            labels[0].setHidden(true)
            labels[1].setHidden(true)
        }
        
        labels[2].setAttributedText(setText(time.secondsString, for: fontSize))
        labels[2].setWidth(labelWidth)
        labels[2].setHeight(labelHeight)
        
        manageLabelColors(timeInterval)
    }
    
    func determineScale(_ time: TimerTime, for collection: WatchLabelCollection) -> CGFloat {
        var multiplier: CGFloat = collection.itemMultiplier
        
        if currentScreenSize == .small {
            multiplier *= 0.85
        }
        
        if time.minutesString == nil {
            multiplier *= 1.5
        } else {
            multiplier *= 1
        }
        
        return multiplier
    }
    
    func setText(_ inputString: String, for size: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: inputString, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: size, weight: UIFontWeightRegular)])
    }
}
