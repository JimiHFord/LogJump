//
//  Hero.swift
//  Log Jump
//
//  Created by James Ford on 6/2/15.
//  Copyright (c) 2015 JWorks. All rights reserved.
//

import Foundation
import SpriteKit

class Hero {
    var velocityY = CGFloat(0)
    var velocityX = 0
    var onGround = true
    var node : SKShapeNode
    var size : CGFloat
    
    init() {
        self.size = CGFloat(5)
        self.node = SKShapeNode(circleOfRadius: size)
        self.node.physicsBody = SKPhysicsBody(circleOfRadius: size)
        self.node.physicsBody!.affectedByGravity = true
    }
    
    func jump(impulse: CGVector) {
        self.node.physicsBody!.affectedByGravity = true
        self.node.physicsBody!.applyImpulse(impulse, atPoint: CGPoint(x: size / 2, y: size / 2))
    }
    
    func landed() {
        self.node.physicsBody!.affectedByGravity = false
    }
}