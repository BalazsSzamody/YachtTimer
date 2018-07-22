//
//  IntExtension.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2018. 07. 22..
//  Copyright © 2018. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation

extension Int {
    func digits() -> (tens: Int, ones: Int) {
        let tens = self / 10
        let ones = self % 10
        return (tens, ones)
    }
    
    var formattedString: String {
        return "\(self)"
    }
}
