//
//  UIExtensions.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 09. 20..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    func add(_ point: CGPoint) -> CGPoint {
        let x = self.x + point.x
        let y = self.y + point.y
        return CGPoint(x: x, y: y)
    }
    
    func add(_ float: CGFloat) -> CGPoint {
        return self.add(CGPoint(x: float, y: float))
    }
    
    func subtract(_ point: CGPoint) -> CGPoint {
        let x = self.x - point.x
        let y = self.y - point.y
        return CGPoint(x: x, y: y)
    }
    
    func subtract(_ float: CGFloat) -> CGPoint {
        return self.subtract(CGPoint(x: float, y: float))
    }
}

extension CGRect {
    func scale(adding float: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x - ( float / 2), y: self.origin.y - ( float / 2), width: self.width + float, height: self.height + float)
    }
    
    func scale(by float: CGFloat) -> CGRect {
        let size: CGSize = CGSize(width: self.width * float, height: self.height * float)
        let origin = CGPoint(x: self.origin.x - (( size.width - self.width ) / 2), y: self.origin.y - (( size.height - self.height ) / 2))
        
        return CGRect(origin: origin, size: size)
    }
}

extension CGSize {
    func aspectRatio() -> CGFloat {
        return self.width / self.height
    }
}

extension UIView {
    func absoluteOrigin() -> CGPoint {
        var origin = self.frame.origin
        
        guard let superview = self.superview else { return origin }
        
        origin = origin.add(superview.absoluteOrigin())
        
        return origin
    }
    
    func origin(in parentView: UIView) -> CGPoint {
        return self.absoluteOrigin().subtract(parentView.absoluteOrigin())
    }
    
    func frameAspectRatio() -> CGFloat {
        return self.frame.size.aspectRatio()
    }
}

extension UIButton {
    public func setUpButton(image: UIImage, color: UIColor) {
        self.setImage(image, for: .normal)
        self.tintColor = color
    }
}

