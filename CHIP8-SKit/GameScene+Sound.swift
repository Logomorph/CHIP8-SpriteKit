//
//  Interpreter+Sound.swift
//  CHIP8-SKit
//
//  Created by Alin Baciu on 30/12/2017.
//  Copyright © 2017 Alin Baciu. All rights reserved.
//

import Cocoa
import AVFoundation

extension GameScene {
    func setupSound() {
        if let sound = NSSound(named: NSSound.Name(rawValue: "beep")) {
            self.beepSound = sound
            self.beepSound.loops = true
        }
    }
    
    func startPlaying() {
        if !self.beepSound.isPlaying {
            self.beepSound.play()
        }
    }
    
    func stopPlaying() {
        if self.beepSound.isPlaying {
            self.beepSound.stop()
        }
    }
}
