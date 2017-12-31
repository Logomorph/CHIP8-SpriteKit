//
//  GameScene.swift
//  CHIP8-SKit
//
//  Created by Alin Baciu on 16/12/2017.
//  Copyright © 2017 Alin Baciu. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, NSDraggingDestination {
    var whiteSprites:[[SKSpriteNode]] = Array(repeating: Array(repeating: SKSpriteNode(), count: 32), count: 64)
    
    var interpreter: Interpreter = Interpreter()
    
    var lastTime:TimeInterval = 0;
    var lastDTTime:TimeInterval = 0;
    
    var simSpeed = 8
    
    var keysPressed:[UInt8: Bool] = [:]
    
    var beepSound = NSSound()
    
    override func didMove(to view: SKView) {
        self.setupMenu()
        self.setupSound()
        for i in 0..<64 {
            for j in 0..<32 {
                let white = SKSpriteNode(color: NSColor.white, size: CGSize(width: 10, height: 10))
                white.position = CGPoint(x: i*10+5, y: (31 - j)*10+5)
                addChild(white)
                let action = SKAction.fadeIn(withDuration: 0.5)
                white.run(action)
                whiteSprites[i][j] = white
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        let elapsedDTTime = currentTime * 1000 - self.lastDTTime
        let elapsedTime = currentTime * 1000 - self.lastTime
        
        if elapsedDTTime >= 1 {
            if self.interpreter.DT > 0 {
                self.interpreter.DT -= 1
            }
            if self.interpreter.ST > 0 {
                self.startPlaying()
                self.interpreter.ST -= 1
            } else {
                self.stopPlaying()
            }
            lastDTTime = currentTime * 1000
        }
        if elapsedTime >= 16 {
            
            // run simSpeed number of steps per frame
            interpreter.keysPressed = self.keysPressed
            for _ in 0...simSpeed {
                if self.interpreter.canRun() {
                    self.interpreter.step()
                }
            }
            self.lastTime = currentTime * 1000
        }
        drawFramebuffer()
    }
    
    func drawFramebuffer() {
        for j in 0...31 {
            for i in 0...63 {
                let isWhite = self.interpreter.vram[j * 64 + i ] == 0
                whiteSprites[i][j].color = isWhite ? NSColor.white : NSColor.black
            }
        }
    }
}
