//
//  StopwatchTimeDisplay.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 08. 15..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation
import WatchKit

enum WatchScreenSize {
    case small
    case big
}

protocol WatchStopwatchTimeDisplay {
    var collections: [WatchLabelCollection]? { get set }
    var currentScreenSize: WatchScreenSize? { get set }
    
    
    func updateDisplay(_ timeInterval: TimeInterval, for collection: WatchLabelCollection)
}

extension WatchStopwatchTimeDisplay {
    
    func updateDisplay(_ timeInterval: TimeInterval, for collection: WatchLabelCollection) {
        let labels = collection.labels
        let time = StopwatchTime(time: timeInterval)
        let multiplier = determineScale(time, for: collection)
        let mainFontSize = 27 * multiplier
        let subFontSize = 23 * multiplier
        let mainLabelWidth = 32 * multiplier
        let subLabelWidth = 28 * multiplier
        let subLabelHeight = 31 * multiplier
        
        
        if let hoursString = time.hoursString {
            labels[0].setHidden(false)
            labels[1].setHidden(false)
            labels[0].setAttributedText(setText(hoursString, for: mainFontSize))
            labels[0].setWidth(mainLabelWidth)
            labels[1].setAttributedText(setText(":", for: mainFontSize))
        } else {
            labels[0].setHidden(true)
            labels[1].setHidden(true)
        }
        
        if let minutesString = time.minutesString {
            labels[2].setHidden(false)
            labels[3].setHidden(false)
            
            labels[2].setAttributedText(setText(minutesString, for: mainFontSize))
            labels[2].setWidth(mainLabelWidth)
            labels[3].setAttributedText(setText(":", for: mainFontSize))
            
            
        } else {
            labels[2].setHidden(true)
            labels[3].setHidden(true)
        }
        
        
        labels[4].setAttributedText(setText(time.secondsString, for: mainFontSize))
        labels[4].setWidth(mainLabelWidth)
        labels[5].setAttributedText(setText(".", for: mainFontSize))
        labels[6].setAttributedText(setText(time.fractionSecondsString, for: subFontSize))
        labels[6].setWidth(subLabelWidth)
        labels[6].setHeight(subLabelHeight)
    }
    
    func determineScale(_ time: StopwatchTime, for collection: WatchLabelCollection) -> CGFloat {
        var multiplier: CGFloat = collection.itemMultiplier
        
        if currentScreenSize == .small {
            multiplier *= 0.85
        }
        
        if time.hoursString == nil {
            if time.minutesString == nil {
                multiplier *= 1.8
            } else {
                multiplier *= 1.4
            }
        }
        
        return multiplier
    }
    
    func setText(_ inputString: String, for size: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: inputString, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular)])
    }
}
