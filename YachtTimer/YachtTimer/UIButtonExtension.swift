//
//  UIButtonExtension.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 09. 04..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    public func setUpButton(image: UIImage, color: UIColor) {
        self.setImage(image, for: .normal)
        self.tintColor = color
    }
}
