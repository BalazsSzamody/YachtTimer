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
    
    let date: Date
    
    init(exist: Bool, shouldStart: Bool, shouldBeCurrentPage: Bool, date: Date) {
        self.exist = exist
        self.shouldStart = shouldStart
        self.shouldBeCurrentPage = shouldBeCurrentPage
        self.date = date
    }
    
    init(_ boolean: Bool) {
        exist = boolean
        shouldStart = boolean
        shouldBeCurrentPage = boolean
        date = Date()
    }
    
}
