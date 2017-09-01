//
//  StopwatchTimeDisplay.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 08. 21..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation
import UIKit

protocol StopwatchTimeDisplay {
    var labelCollections: [PhoneLabelCollection] { get set }
    
    func updateDisplay(_ timeInterval: TimeInterval, for labelCollection: PhoneLabelCollection)
    func updateNewDisplay(_ timeInterval: TimeInterval, for labelCollection: PhoneLabelCollection)
}

extension StopwatchTimeDisplay {
    func updateDisplay(_ timeInterval: TimeInterval, for labelCollection: PhoneLabelCollection) {
        let labels = labelCollection.labels
        let stackView = labelCollection.stackView
        
        let time = StopwatchTime(time: timeInterval)
        
        
        if let hoursString = time.hoursString {
            labels[0].isHidden = false
            labels[1].isHidden = false
            labels[0].text = hoursString
        } else {
            labels[0].isHidden = true
            labels[1].isHidden = true
        }
        
        if let minutesString = time.minutesString {
            labels[2].isHidden = false
            labels[3].isHidden = false
            labels[2].text = minutesString
        } else {
            labels[2].isHidden = true
            labels[3].isHidden = true
        }
        
        
        let scale = determineScale(for: labels)
        setStackViewSize(scale, for: stackView)
        
        
        labels[4].text = time.secondsString
        
        labels[6].text = time.fractionSecondsString
    }
    
    func updateNewDisplay(_ timeInterval: TimeInterval, for labelCollection: PhoneLabelCollection) {
        let labels = labelCollection.labels
        let stackView = labelCollection.stackView
        
        let time = NewStopwatchTime(time: timeInterval)
        
        
        
        if let hourSecond = time.hourSecond {
            labels[0].isHidden = false
            labels[1].isHidden = false
            labels[2].isHidden = false
            
            labels[0].text = time.hourFirst
            labels[1].text = hourSecond
        } else {
            labels[0].isHidden = true
            labels[1].isHidden = true
            labels[2].isHidden = true
        }
        
        if let minuteSecond = time.minuteSecond {
            labels[3].isHidden = false
            labels[4].isHidden = false
            labels[5].isHidden = false
            
            labels[3].text = time.minuteFirst
            labels[4].text = minuteSecond
        } else {
            labels[3].isHidden = true
            labels[4].isHidden = true
            labels[5].isHidden = true
        }
        
        labels[6].text = time.secondFirst
        labels[7].text = time.secondSecond
        
        labels[9].text = time.fractionSecondFirst
        labels[10].text = time.fractionSecondSecond
        
        let scale = determineNewScale(for: labels, baseMultiplier: labelCollection.itemMultiplier)
        setStackViewSize(scale, for: stackView)
    }
    
    func determineScale(for labels: [UILabel]) -> CGFloat {
        //determine scale based on how many labels are hidden
        var scaleCounter = 0
        for label in labels {
            if label.isHidden {
                scaleCounter += 1
            }
        }
        switch scaleCounter {
        case 1 ... 2:
            return 1.33
        case 3 ... 4:
            return 1.66
        default:
            return 1
        }
    }
    
    func determineNewScale(for labels: [UILabel], baseMultiplier: CGFloat) -> CGFloat {
        var scaleCounter = 0
        for label in labels {
            if label.isHidden {
                scaleCounter += 1
            }
            
        }
        
        switch scaleCounter {
        case 1 ... 3:
            return 1.33 * baseMultiplier
        case 4 ... 6:
            return 1.66 * baseMultiplier
        default:
            return baseMultiplier
        }
    }
    
    func setStackViewSize(_ scale: CGFloat, for stackView: UIStackView) {
        //set the size of the visible Labels
        stackView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}
