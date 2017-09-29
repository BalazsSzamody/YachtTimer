//
//  PhoneScreenSize.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 09. 11..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation
import UIKit

enum DeviceSize {
    case iphone4
    case iphoneSE
    case iphone
    case iphonePlus
    case ipad
    case ipadProSmall
    case ipadProBig
}

struct PhoneScreen: CustomStringConvertible {
    var deviceSize: DeviceSize
    var orientation: Bool
    
    var description: String {
        return "screenSize: \(deviceSize), orientation: \(orientation)"
    }
    
    static var currentScreen: PhoneScreen {
        return PhoneScreen(deviceSize: getDevice(), orientation: UIDevice.current.orientation.isLandscape)
    }
    
    static var interfaceMultiplier: CGFloat {
        return PhoneScreen.setInterfaceSize()
    }
    
    
    /*static func getCurrentScreen() {
        
        
        let orientation = UIDevice.current.orientation
        
        currentScreen = PhoneScreen(deviceSize: getDevice(), orientation: orientation)
        
    }
 */
    
    static func getDevice() -> DeviceSize {
        let screenSize = UIScreen.main.bounds
        let screenDimensions = [screenSize.width, screenSize.height]
        let deviceHeight = screenDimensions.max()!
        
        switch deviceHeight {
        case 560 ... 570:
            return .iphoneSE
        case 660 ... 670:
            return .iphone
        case 730 ... 740:
            return .iphonePlus
        case 1020 ... 1030:
            return .ipad
        case 1110 ... 1120:
            return .ipadProSmall
        case 1360 ... 1370:
            return .ipadProBig
        default:
            return .iphone4
        }
    }
    
    static func setInterfaceSize() -> CGFloat {
        switch getDevice() {
        case .iphoneSE, .iphone4:
            return 1
        case .iphone:
            return 1.3
        case .iphonePlus:
            return 1.35
        case .ipad:
            return 2
        case .ipadProSmall:
            return 2.4
        case .ipadProBig:
            return 3
            
        }
    }
}
