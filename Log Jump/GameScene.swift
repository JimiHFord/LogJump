//
//  GameScene.swift
//  Log Jump
//
//  Created by James Ford on 6/23/14.
//  Copyright (c) 2014 JWorks. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let playButton = SKSpriteNode(imageNamed:"play")
    
    override func didMoveToView(view: SKView) {
        // anything that starts with CG usually you instantiate it with its own "make"
        self.playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(self.playButton)
        
        self.backgroundColor = UIColor(hex: 0x80D9FF)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch:AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == playButton {
                var scene = PlayScene(size: self.size)
                let skView = self.view as SKView?
                skView!.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView!.bounds.size
                skView!.presentScene(scene)
                skView?.showsFPS = true
                skView?.showsNodeCount = true
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
