//
//  HelpImageSet.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 09. 11..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation
import UIKit

struct HelpImageSet: CustomStringConvertible {
    let timerImage: UIImage
    let simpleStopwatchImage: UIImage
    let lappedStopwatchImage: UIImage
    
    var description: String {
        return "\(timerImage), \(simpleStopwatchImage), \(lappedStopwatchImage)"
    }
    
    static var portraitSet: HelpImageSet?
    static var landscapeSet: HelpImageSet?
    
    static let finishedSizes: [DeviceSize] = [.iphoneSE]
    
    static func createImageSet(deviceSize: DeviceSize) {
        guard finishedSizes.contains(deviceSize) else {
            portraitSet = nil
            landscapeSet = nil
            return
        }
        let timerImage = UIImage(imageLiteralResourceName: "helpOverlay_P_Timer_\(deviceSize)")
        let simpleStopwatchImage = UIImage(imageLiteralResourceName: "helpOverlay_P_Stopwatch_\(deviceSize)")
        let lappedStopwatchImage = UIImage(imageLiteralResourceName: "helpOverlay_P_Stopwatch_Lap_\(deviceSize)")
        portraitSet = HelpImageSet(timerImage: timerImage, simpleStopwatchImage: simpleStopwatchImage, lappedStopwatchImage: lappedStopwatchImage)
        
        let landscapeTimerImage = UIImage(imageLiteralResourceName: "helpOverlay_L_Timer_\(deviceSize)")
        let landscpaeSimpleStopwatchImage = UIImage(imageLiteralResourceName: "helpOverlay_L_Stopwatch_\(deviceSize)")
        let landscapeLappedStopwatchImage = UIImage(imageLiteralResourceName: "helpOverlay_L_Stopwatch_Lap_\(deviceSize)")
        landscapeSet = HelpImageSet(timerImage: landscapeTimerImage, simpleStopwatchImage: landscpaeSimpleStopwatchImage, lappedStopwatchImage: landscapeLappedStopwatchImage)
    }
}
