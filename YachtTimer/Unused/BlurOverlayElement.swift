//
//  BlurOverlayProtocol.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 09. 12..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

/*
import Foundation
import CoreImage
import UIKit

struct BlurOverlayElement {
    let view: UIView
    let imageView: UIImageView?
    let blurRadius: CGFloat?
    var blurredImage: UIImage? {
        didSet{
            guard let imageView = imageView, let blurredImage = blurredImage else { return }
            DispatchQueue.main.async {
                imageView.image = blurredImage
            }
        }
    }
    
    init(_ uiView: UIView, parentView: UIView?, blur radius: CGFloat?) {
        view = uiView
        blurRadius = radius
        if let parentView = parentView {
            let extraSpace: CGFloat = 0
            let viewOrigin = uiView.origin(in: parentView)
            imageView = UIImageView(frame: CGRect(origin: viewOrigin, size: uiView.frame.size).scale(adding: extraSpace))
            imageView!.transform = uiView.transform
            imageView!.frame.origin = viewOrigin
            imageView!.alpha = 0.6
            //blurredImage = OverlayElement.blurView(uiView, with: radius)
        } else {
            imageView = nil
            blurredImage = nil
        }
    }
    
    /*
    mutating func generateBlurredView() {
        DispatchQueue.global(qos: .userInitiated).async {
            print(self.view.frame.size)
            let start = Date()
            print("start", Date().timeIntervalSince(start))
            
            guard let blur = CIFilter(name: "CiGaussianBlur") else {
                print("no such filter")
                return
            }
            print("filterReady", Date().timeIntervalSince(start))
            
            guard let image = self.getImageContext() else {
                print("image context failed")
                return
            }
            print("inputImageReady", Date().timeIntervalSince(start))
            
            blur.setValue(CIImage(image: image), forKey: kCIInputImageKey)
            guard let radius = self.blurRadius else { return }
            blur.setValue(radius, forKey: kCIInputRadiusKey)
            
            let ciContext = CIContext()
            print("ciContext ready", Date().timeIntervalSince(start))
            guard let result = blur.value(forKey: kCIOutputImageKey) as! CIImage! else {
                print("Result image failed")
                return
            }
            print("blurReady", Date().timeIntervalSince(start))
            let boundingRectangle = CGRect(origin: CGPoint.zero, size: self.view.frame.size )
            let cgImage = ciContext.createCGImage(result, from: boundingRectangle)
            print("cgImageReady", Date().timeIntervalSince(start))
            self.blurredImage = UIImage(cgImage: cgImage!)
        }
    }
    mutating func getImageContext() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 1)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    mutating func refreshImage() {
        guard let imageView = imageView, let blurredImage = blurredImage else { return }
        DispatchQueue.main.async {
            imageView.image = blurredImage
        }
    }
    */
    static var elements: [OverlayElement] = []
    
    static func addElement(_ view: UIView, parentView: UIView?, blur radius: CGFloat?) {
        guard !view.isHidden else { return }
        elements.append( BlurOverlayElement(view, parentView: parentView, blur: radius) )
        var element = elements[elements.count - 1]
        if let parentView = parentView {
            guard let imageView = element.imageView else { return }
            parentView.insertSubview(imageView, at: 1)
            guard let image = element.blurredImage else { return }
            imageView.image = image
            element.blurredImage = BlurOverlayElement.blurView(element.view, with: element.blurRadius!)
        }
    }
    
    static func insertElement(_ view: UIView, parentView: UIView?, blur radius: CGFloat?, at index: Int) {
        guard !view.isHidden else { return }
        elements.insert( BlurOverlayElement(view, parentView: parentView, blur: radius), at: index )
        let element = elements[index]
        if let parentView = parentView {
            guard let imageView = element.imageView else { return }
            parentView.insertSubview(imageView, at: 1)
            guard let image = element.blurredImage else { return }
            imageView.image = image
        }
    }
    
    static func addElements(_ views: [UIView], parentView: UIView?, blur radius: CGFloat?) {
        for view in views {
            addElement(view, parentView: parentView, blur: radius)
        }
    }
    
    static func removeElements() {
        for _ in elements {
            let removedElement = elements.removeFirst()
            if let imageView = removedElement.imageView {
                imageView.removeFromSuperview()
            }
        }
    }
    
    func reloadElement(at index: Int) {
        guard let parentView = self.imageView?.superview else { return }
        let blurRadius = self.blurRadius
        let removedElement = BlurOverlayElement.elements.remove(at: index)
        removedElement.imageView!.removeFromSuperview()
        BlurOverlayElement.insertElement(self.view, parentView: parentView, blur: blurRadius, at: index)
        
    }
    
    static func updateBlurredElements() {
        for (i, var element) in elements.enumerated() {
            
            if let imageView = element.imageView {
                element.blurredImage = BlurOverlayElement.blurView(element.view, with: element.blurRadius!)
                let condition1 = imageView.frameAspectRatio() > element.blurredImage!.size.aspectRatio() - 0.1
                let condition2 = imageView.frameAspectRatio() < element.blurredImage!.size.aspectRatio() + 0.1
                if  !(condition1 && condition2) {
                    element.reloadElement(at: i)
                }
            }
        }
    }
    
   
    static func blurView(_ uiView: UIView, with radius: CGFloat) -> UIImage? {
        print(uiView.frame.size)
        let extraSpace: CGFloat = 0
        guard let blur = CIFilter(name: "CIGaussianBlur") else {
            print("filter failed")
            return nil
        }
        
        guard let image = getImageContext(uiView: uiView, blur: radius) else {
            print("image failed")
            return nil
        }
        
        blur.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        blur.setValue(radius, forKey: kCIInputRadiusKey)
        
        let ciContext = CIContext(options: nil)
        guard let result = blur.value(forKey: kCIOutputImageKey) as! CIImage! else {
            print("result image failed")
            return nil
        }
        let boundingRectangle = CGRect(x: 0, y: 0, width: uiView.frame.width, height: uiView.frame.height).scale(adding: extraSpace)
        
        let cgImage = ciContext.createCGImage(result, from: boundingRectangle)
        let filteredImage = UIImage(cgImage: cgImage!)
        return filteredImage
        
    }
    
    static func getImageContext(uiView: UIView, blur radius: CGFloat) -> UIImage? {
        let extraSpace: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(CGSize(width: uiView.frame.width + extraSpace, height: uiView.frame.height + extraSpace), false, 1)
        uiView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

*/
