//
//  OverlayElement.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 09. 20..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation
import UIKit

class OverlayElement {
    let view: UIView
    let imageView: UIImageView
    
    let parentView: UIView
    
    var image: UIImage? = nil {
        didSet {
            if image != nil {
                imageView.image = image
                print(image!.size)
            } else {
                print("no image")
            }
            
        }
    }
    
    init(view: UIView, parentView: UIView) {
        self.view = view
        self.parentView = parentView
        imageView = UIImageView(frame: view.frame)
        imageView.alpha = 0.5
        parentView.addSubview(imageView)
        imageView.frame.origin = view.origin(in: parentView)
    }
    
    deinit {
        imageView.removeFromSuperview()
    }
    
    func getImage() -> UIImage? {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func remove() {
        imageView.removeFromSuperview()
    }
    
    static func addElement(view: UIView, parentView: UIView) -> OverlayElement {
        let element = OverlayElement(view: view, parentView: parentView)
        element.image = element.getImage()
        
        return element
    }
    
    
}
