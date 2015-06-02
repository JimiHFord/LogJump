//
//  BlockEngine.swift
//  Log Jump
//
//  Created by James Ford on 7/26/14.
//  Copyright (c) 2014 JWorks. All rights reserved.
//

import Foundation
import CoreGraphics

func rnd() -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
}

class BlockEngine {
    
    func pick() -> Platform {
        let width = (rnd() * 50) + 25
        let height = CGFloat(10)
        let retVal = NormalPlatform(width: width, height: height, cornerRadius: CGFloat(5))
        return retVal
    }
}