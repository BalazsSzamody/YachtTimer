//
//  Sarge.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 08. 04..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation

struct Context {
    
    let exist: Bool
    
    let shouldStart: Bool
    
    let shouldBeCurrentPage: Bool
    
    init(exist: Bool, shouldStart: Bool, shouldBeCurrentPage: Bool) {
        self.exist = exist
        self.shouldStart = shouldStart
        self.shouldBeCurrentPage = shouldBeCurrentPage
    }
    
    init(_ boolean: Bool) {
        exist = boolean
        shouldStart = boolean
        shouldBeCurrentPage = boolean
    }
    
}
