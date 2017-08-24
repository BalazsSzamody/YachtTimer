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
    var labelCollections: [LabelCollection] { get set }
    
    func updateDisplay(_ timeInterval: TimeInterval, for labelCollection: LabelCollection)
}

extension StopwatchTimeDisplay {
    func updateDisplay(_ timeInterval: TimeInterval, for labelCollection: LabelCollection) {
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
    
    func setStackViewSize(_ scale: CGFloat, for stackView: UIStackView) {
        //set the size of the visible Labels
        stackView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}
