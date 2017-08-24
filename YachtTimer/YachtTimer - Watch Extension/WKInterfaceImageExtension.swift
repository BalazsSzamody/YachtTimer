//
//  WKInterfaceImageExtension.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 08. 22..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation
import WatchKit

struct ButtonImage {
    let image: UIImage
    let color: UIColor
}

extension WKInterfaceImage {
    
    func setImageAndColor(_ image: ButtonImage) {
        setImage(image.image)
        setTintColor(image.color)
    }
}
