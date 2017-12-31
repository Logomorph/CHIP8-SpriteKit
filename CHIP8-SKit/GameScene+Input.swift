//
//  GamesScene+Input.swift
//  CHIP8-SKit
//
//  Created by Alin Baciu on 30/12/2017.
//  Copyright © 2017 Alin Baciu. All rights reserved.
//

import Cocoa

extension GameScene {
    override func mouseDown(with event: NSEvent) {
        if !self.interpreter.romLoaded {
            self.openRomFile()
        }
    }
    
    override func keyUp(with event: NSEvent) {
        if let characters = event.characters {
            for character in characters {
                switch character {
                case "+":
                    self.simSpeed += 1
                    break
                case "-":
                    self.simSpeed -= 1
                    if simSpeed < 0 {
                        simSpeed = 0
                    }
                    break
                case "1": // 1
                    keysPressed[0x1] = false
                    break
                case "2": // 2
                    keysPressed[0x2] = false
                    break
                case "3": // 3
                    keysPressed[0x3] = false
                    break
                case "4": // C
                    keysPressed[0xC] = false
                    break
                    
                case "q": // 4
                    keysPressed[0x4] = false
                    break
                case "w": // 5
                    keysPressed[0x5] = false
                    break
                case "e": // 6
                    keysPressed[0x6] = false
                    break
                case "r": // D
                    keysPressed[0xD] = false
                    break
                    
                case "a": // 7
                    keysPressed[0x7] = false
                    break
                case "s": // 8
                    keysPressed[0x8] = false
                    break
                case "d": // 9
                    keysPressed[0x9] = false
                    break
                case "f": // E
                    keysPressed[0xE] = false
                    break
                    
                case "z": // A
                    keysPressed[0xA] = false
                    break
                case "x": // 0
                    keysPressed[0x0] = false
                    break
                case "c": // B
                    keysPressed[0xB] = false
                    break
                case "v": // F
                    keysPressed[0xF] = false
                    break
                    
                default:
                    break
                }
            }
        }
    }
    
    override func keyDown(with event: NSEvent) {
        if let characters = event.characters {
            for character in characters {
                switch character {
                case "1": // 1
                    keysPressed[0x1] = true
                    break
                case "2": // 2
                    keysPressed[0x2] = true
                    break
                case "3": // 3
                    keysPressed[0x3] = true
                    break
                case "4": // C
                    keysPressed[0xC] = true
                    break
                    
                case "q": // 4
                    keysPressed[0x4] = true
                    break
                case "w": // 5
                    keysPressed[0x5] = true
                    break
                case "e": // 6
                    keysPressed[0x6] = true
                    break
                case "r": // D
                    keysPressed[0xD] = true
                    break
                    
                case "a": // 7
                    keysPressed[0x7] = true
                    break
                case "s": // 8
                    keysPressed[0x8] = true
                    break
                case "d": // 9
                    keysPressed[0x9] = true
                    break
                case "f": // E
                    keysPressed[0xE] = true
                    break
                    
                case "z": // A
                    keysPressed[0xA] = true
                    break
                case "x": // 0
                    keysPressed[0x0] = true
                    break
                case "c": // B
                    keysPressed[0xB] = true
                    break
                case "v": // F
                    keysPressed[0xF] = true
                    break
                    
                default:
                    break
                }
            }
        }
    }
}
