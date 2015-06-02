//
//  PlayScene.swift
//  Log Jump
//
//  Created by James Ford on 7/26/14.
//  Copyright (c) 2014 JWorks. All rights reserved.
//

import SpriteKit

class PlayScene: SKScene, SKPhysicsContactDelegate {
    
    let runningBar = SKSpriteNode(imageNamed:"bar")
//    let hero = SKSpriteNode(imageNamed:"hero")
    let hero = Hero()
    var score = UInt32(0)
    let scoreText = SKLabelNode(fontNamed:"Chalkduster")
    
    var originRunningBarPositionX = CGFloat(0)
    var maxBarX = CGFloat(0)
    let shortBlock = SKSpriteNode(imageNamed:"short_block")
    let tallBlock = SKSpriteNode(imageNamed:"tall_block")
    var groundSpeed = CGFloat(3.5)
    var heroBaseLine = CGFloat(0)
    let gravity = CGFloat(0.6)
    
    let gd = GameDifficulty()
    let ben = BlockEngine()
    
//    let jumpSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("jump", ofType: "wav"))
    
    var blockMaxX = CGFloat(0)
    var originBlockPositionX = CGFloat(0)
    
    enum ColliderType:UInt32 {
        case Hero = 1
        case Block = 2
    }
    
    func didBeginContact(contact:SKPhysicsContact) {
        died()
    }
    
    func died() {
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            let skView = self.view as SKView?
            skView!.ignoresSiblingOrder = true
            scene.size = skView!.bounds.size
            scene.scaleMode = .AspectFill
            skView!.presentScene(scene)

        }
    }
    
    var blockStatuses:Dictionary<String, BlockStatus> = [:]
    
    /// initialize view
    override func didMoveToView(view: SKView) {
        
        // set background
        self.backgroundColor = UIColor(hex: 0x80D9FF)
//        let s = SKSpriteNode(
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -0.2)
        self.runningBar.anchorPoint = CGPointMake(0, 0.5)
        self.runningBar.position = CGPointMake(
            CGRectGetMinX(self.frame),
            CGRectGetMinY(self.frame) + (self.runningBar.size.height / 2))

        self.originRunningBarPositionX = self.runningBar.position.x
        self.maxBarX = self.runningBar.size.width - self.frame.size.width
        self.maxBarX *= -1
        
        self.heroBaseLine = self.runningBar.position.y + (self.runningBar.size.height / 2) + (self.hero.size/2)
        self.hero.node.position = CGPointMake(CGRectGetMinX(self.frame) + self.hero.size + (self.hero.size / 4), self.heroBaseLine)
        
        
//        self.hero.physicsBody.categoryBitMask = ColliderType.Hero.toRaw()
//        self.hero.physicsBody.contactTestBitMask = ColliderType.Block.toRaw()
//        self.hero.physicsBody.collisionBitMask = ColliderType.Block.toRaw()
        
        //blocks
        self.shortBlock.position = CGPointMake(CGRectGetMaxX(self.frame) + self.shortBlock.size.width , self.heroBaseLine)
        self.tallBlock.position = CGPointMake(CGRectGetMaxX(self.frame) + self.tallBlock.size.width, self.heroBaseLine + self.tallBlock.size.height / 4)
        
        self.originBlockPositionX = self.shortBlock.position.x
        
        self.shortBlock.name = "shortBlock"
        self.tallBlock.name = "tallBlock"
        
        self.shortBlock.physicsBody = SKPhysicsBody(rectangleOfSize:self.shortBlock.size)
        self.shortBlock.physicsBody!.dynamic = true
        self.shortBlock.physicsBody!.affectedByGravity = true
        self.shortBlock.physicsBody!.categoryBitMask = ColliderType.Block.rawValue
        self.shortBlock.physicsBody!.contactTestBitMask = ColliderType.Hero.rawValue
        self.shortBlock.physicsBody!.collisionBitMask = ColliderType.Hero.rawValue

        self.tallBlock.physicsBody = SKPhysicsBody(rectangleOfSize:self.tallBlock.size)
        self.tallBlock.physicsBody!.dynamic = true
        self.tallBlock.physicsBody!.affectedByGravity = true
        self.tallBlock.physicsBody!.categoryBitMask = ColliderType.Block.rawValue
        self.tallBlock.physicsBody!.contactTestBitMask = ColliderType.Hero.rawValue
        self.tallBlock.physicsBody!.collisionBitMask = ColliderType.Hero.rawValue
        
        blockStatuses["shortBlock"] = BlockStatus(isRunning: false, timeGapForNextRun: random(), currentInterval: UInt32(0))
        blockStatuses["tallBlock"] = BlockStatus(isRunning: false, timeGapForNextRun: random(), currentInterval: UInt32(0))
        
        self.scoreText.text = "0"
        self.scoreText.fontSize = 42
        self.scoreText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        self.blockMaxX = 0 - self.shortBlock.size.width / 2
        
//        self.addChild(self.scoreText)
//        self.addChild(self.runningBar)
        self.addChild(self.hero.node)
//        self.addChild(self.shortBlock)
//        self.addChild(self.tallBlock)
    }
    
    func random() -> UInt32 {
        var range = UInt32(50)..<UInt32(200)
        return range.startIndex + arc4random_uniform(range.endIndex - range.startIndex + 1)
    }
    

    
    override func update(currentTime: NSTimeInterval) {
        if self.hero.node.position.y <= self.heroBaseLine {
            self.hero.node.position.y = self.heroBaseLine
            self.hero.velocityY = 0.0
            self.hero.landed()
        }
        
        dropBlock()
    }

    func dropBlock() {
        if gd.shouldDropPlatform() {
            let block = ben.pick()
            let node = block.node
            node.physicsBody!.dynamic = true
            node.physicsBody!.affectedByGravity = true
//            node.physicsBody.categoryBitMask = ColliderType.node.toRaw()
//            node.physicsBody.contactTestBitMask = ColliderType.Hero.toRaw()
//            node.physicsBody.collisionBitMask = ColliderType.Hero.toRaw()
            positionBlock(node)
            self.addChild(node)
//            node.physicsBody!.applyTorque(CGFloat(0.05))
            node.physicsBody!.applyImpulse(CGVectorMake(-3, 0))
        }
    }
    
    func rndFlt() -> CGFloat {
        let res = UInt(arc4random())
//        println("rndInt() -> \(res)")
        return CGFloat(res)
    }
    
    func positionBlock(block:SKNode) {
        let xOffset = rndFlt() % self.frame.width
        let v = CGVectorMake(rndFlt(), 0)
        println("v(\(v.dx), \(v.dy))")
        block.position = CGPointMake(xOffset, CGRectGetMaxY(self.frame) + block.frame.height * 2)
        

        
    }
    
    /// this is for the old game that i modified
    /// blocks come in and you have to jump over them
    func blockRunner() {
        for(block, blockStatus) in self.blockStatuses {
            var thisBlock = self.childNodeWithName(block)
            if blockStatus.shouldRunBlock() {
                blockStatus.timeGapForNextRun = random()
                blockStatus.currentInterval = 0
                blockStatus.isRunning = true
            }
            
//            let blockMaxX
            
            if blockStatus.isRunning {
                if thisBlock!.position.x > blockMaxX {
                    thisBlock!.position.x -= CGFloat(self.groundSpeed)
                }
                else {
                    thisBlock!.position.x = self.originBlockPositionX
                    blockStatus.isRunning = false
                    self.score++
                    if self.score % 3 == 0 {
                        self.groundSpeed += 0.1
                    }
                    self.scoreText.text = String(self.score)
                }
            } else {
                blockStatus.currentInterval++
            }
        }
    }
    
    // jump / launch
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.hero.jump(CGVector(dx: CGFloat(0), dy: CGFloat(0.4)))
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
//        if self.hero.velocityY < -9.0 {
//            self.hero.velocityY = -9.0
//        }
    }
}
