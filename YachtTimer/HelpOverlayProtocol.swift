//
//  HelpOverlayProtocol.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 09. 08..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation
import UIKit

protocol HelpOverlayProtocol {
    var buttonGroup: [UIButton] { get set }
    weak var helpButton: UIButton! { get set }
    weak var overlayView: UIView! { get set }
    weak var overlayImage: UIImageView! { get set }
    weak var closeOverlayLeftButton: UIButton! { get set }
    
    func helpButtonPressed(_ sender: Any)
    func closeOverlayLeftButtonPressed(_ sender: Any)
    func prepareOverlaysAndButtons()
    func prepareOverlayImage(isOrientationLandscape: Bool) 
}

extension HelpOverlayProtocol {
    func showHelpOverlay() {
        prepareOverlayImage(isOrientationLandscape: PhoneScreen.currentScreen.orientation)
        //setControlButtonsHidden(true)
        setControlButtonsColor(transparent: true)
        overlayView.isHidden = false
     }
    
    func hideHelpOverlay() {
        //setControlButtonsHidden(false)
        setControlButtonsColor(transparent: false)
        overlayView.isHidden = true
    }
    
    func setControlButtonsHidden(_ bool: Bool) {
        for button in buttonGroup {
            if let imageView = button.imageView {
               imageView.isHidden = bool
            }
        }
        helpButton.isHidden = bool
    }
    
    func setControlButtonsColor(transparent bool: Bool) {
        for button in buttonGroup {
            if bool {
                button.tintColor = InterfaceColor.transparent
            } else {
                guard let image = button.image(for: .normal) else { return }
                switch image {
                case #imageLiteral(resourceName: "startIcon"):
                    button.tintColor = InterfaceColor.brightGreen
                case #imageLiteral(resourceName: "syncIcon"):
                    button.tintColor = InterfaceColor.brightGreen
                case #imageLiteral(resourceName: "resetIcon"):
                    button.tintColor = InterfaceColor.brightGreen
                case #imageLiteral(resourceName: "closeIcon"):
                    button.tintColor = InterfaceColor.brightRed
                case #imageLiteral(resourceName: "pauseIcon"):
                    button.tintColor = InterfaceColor.brightRed
                default:
                    button.tintColor = InterfaceColor.blue
                }
            }
        }
    }
    
    
}
