//
//  InterfaceColor.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 09. 04..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation
import UIKit

class InterfaceColor {
    var color: UIColor
    
    init(color: UIColor) {
        self.color = color
    }
    
    static let green = UIColor(red: 27/255, green: 178/255, blue: 0/255, alpha: 1)
    static let yellow = UIColor(red: 254/255, green: 246/255, blue: 0/255, alpha: 1)
    static let red = UIColor(red: 255/255, green: 9/255, blue: 1/255, alpha: 1)
    static let blue = UIColor(red: 34/255, green: 168/255, blue: 255/255, alpha: 1)
    static let lightBlue = UIColor(red: 93/255, green: 191/255, blue: 255/255, alpha: 1)
    static let offWhite = UIColor(red: 197/255, green: 226/255, blue: 196/255, alpha: 1)
    static let brightGreen = UIColor(red: 106/255, green: 242/255, blue: 84/255, alpha: 1)
    static let brightRed = UIColor(red: 223/255, green: 114/255, blue: 109/255, alpha: 1)
    static let brightYellow = UIColor(red: 255/255, green: 251/255, blue: 80/255, alpha: 1)
    static let white = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    static let transparent = UIColor(white: 1, alpha: 0)
    
    static let defaultColor = InterfaceColor.brightGreen
    static let withinOneMinuteColor = InterfaceColor.brightRed
    static let withinTwoMinutesColor = InterfaceColor.brightYellow
}

