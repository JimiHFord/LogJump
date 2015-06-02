//
//  GameDifficulty.swift
//  Log Jump
//
//  Created by James Ford on 7/26/14.
//  Copyright (c) 2014 JWorks. All rights reserved.
//

import Foundation

class GameDifficulty {
    
    let rndMax = UInt32(10000)
    let platformSpawnIncrement = UInt32(1)
    let platformSpawnDecrement = -0.001
    var platformSpawnRate = UInt32(500)
    var platformObstaclesEnabled = false
    var airborneObstaclesEnabled = false
    
    
    
    init() {
        
    }
    
    func shouldDropPlatform() -> Bool {
        let rnd = arc4random_uniform(rndMax) // number between 0..10,000
        return rnd <= self.platformSpawnRate
    }
}