//
//  GameScene.swift
//  Pong
//
//  Created by Eric Liu on 2017-09-01.
//  Copyright © 2017 Eric Liu. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    /*
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    */
        
        var ball = SKSpriteNode()
        var enemy = SKSpriteNode()
        var main = SKSpriteNode()
        
        var topLbl = SKLabelNode()
        var btmLbl = SKLabelNode()
        
        var score = [Int]()
        
        override func didMove(to view: SKView) {
            
            topLbl = self.childNode(withName: "topLabel") as! SKLabelNode
            btmLbl = self.childNode(withName: "btmLabel") as! SKLabelNode
            ball = self.childNode(withName: "ball") as! SKSpriteNode
            
            print(self.view?.bounds.height)
            
            enemy = self.childNode(withName: "enemy") as! SKSpriteNode
            enemy.position.y = (self.frame.height / 2) - 50
            
            main = self.childNode(withName: "main") as! SKSpriteNode
            main.position.y = (-self.frame.height / 2) + 50
            
            let border = SKPhysicsBody(edgeLoopFrom: self.frame)
            
            border.friction = 0
            border.restitution = 1
            
            self.physicsBody = border
            
            startGame()
        }
        
        func startGame() {
            score = [0,0]
            topLbl.text = "\(score[1])"
            btmLbl.text = "\(score[0])"
            ball.physicsBody?.applyImpulse(CGVector(dx: 10 , dy: 10))
        }
        
        func addScore(playerWhoWon : SKSpriteNode){
            ball.position = CGPoint(x: 0, y: 0)
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            if playerWhoWon == main {
                score[0] += 1
                ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
            }
            else if playerWhoWon == enemy {
                score[1] += 1
                ball.physicsBody?.applyImpulse(CGVector(dx: -10, dy: -10))
            }
            topLbl.text = "\(score[1])"
            btmLbl.text = "\(score[0])"
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                
                if currentGameType == .player2 {
                    if location.y > 0 {
                        enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                    }
                    if location.y < 0 {
                        main.run(SKAction.moveTo(x: location.x, duration: 0.2))
                    }
                }
                else {
                    main.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
            }
        }
    
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                
                if currentGameType == .player2 {
                    if location.y > 0 {
                        enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                    }
                    if location.y < 0 {
                        main.run(SKAction.moveTo(x: location.x, duration: 0.2))
                    }
                }
                else {
                    main.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
            }
        }
        
        override func update(_ currentTime: TimeInterval) {
            // Called before each frame is rendered
            switch currentGameType {
            case .easy:
                enemy.run(SKAction.moveTo(x: ball.position.x, duration: 1.3))
                break
                
            case .medium:
                
                enemy.run(SKAction.moveTo(x: ball.position.x, duration: 1.0))
                break
                
            case .hard:
                enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.7))
                break
                
            case .player2:
                break
            }
            
            if ball.position.y <= main.position.y - 30 {
                addScore(playerWhoWon: enemy)
            }
            else if ball.position.y >= enemy.position.y + 30 {
                addScore(playerWhoWon: main)
            }
        }
}
        
        
        /*
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    */
