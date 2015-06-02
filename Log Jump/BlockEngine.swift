//
//  BlockEngine.swift
//  Log Jump
//
//  Created by James Ford on 7/26/14.
//  Copyright (c) 2014 JWorks. All rights reserved.
//

import Foundation

class BlockEngine {
    let platforms = [ "short_block", "tall_block"]
    
    func pick() -> String {
        let result = Int(arc4random_uniform(UInt32(platforms.count)))
        return platforms[result]
    }
}