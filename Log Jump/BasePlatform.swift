//
//  BasePlatform.swift
//  Log Jump
//
//  Created by James Ford on 6/2/15.
//  Copyright (c) 2015 JWorks. All rights reserved.
//

import Foundation
import SpriteKit

class BasePlatform : Platform {
    var width : CGFloat
    var height : CGFloat
    var node : SKShapeNode
    
    init(width: CGFloat, height: CGFloat, cornerRadius: CGFloat) {
        self.width = width
        self.height = height
        self.node = SKShapeNode(rect: CGRectMake(CGFloat(0), CGFloat(0), width, height), cornerRadius: cornerRadius)
        self.node.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: width, height: height))
    }
}