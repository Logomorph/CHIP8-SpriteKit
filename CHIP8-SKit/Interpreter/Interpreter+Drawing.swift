//
//  Interpreter+Drawing.swift
//  CHIP8
//
//  Created by Alin Baciu on 16/12/2017.
//  Copyright © 2017 Alin Baciu. All rights reserved.
//

import Cocoa

extension Interpreter {
    func clearVram() {
        for i in 0..<self.vram.count {
            self.vram[i] = 0x0
        }
    }
    func draw(x:Int, y:Int, bytes:Int) {
        var X = x
        var Y = y
        self.registers[VF] = 0x0
        var memoryLocation = I
        for _ in 1...bytes {
            var byte = ram[Int(memoryLocation)]
            for _ in 1...8 {
                if X >= 0 && X <= 63 && Y >= 0 && Y <= 31 {
                    let bit = (byte & 0b10000000) >> 7
                    byte = byte << 1
                    var color = self.vram[Y*64 + X]
                    let backup = color
                    color = backup ^ bit
                    self.vram[Y*64 + X] = color
                    if (backup != 0 && color == 0) {
                        self.registers[VF] = 0x1
                    }
                }
                X+=1
            }
            memoryLocation += 1
            Y+=1
            X=x
        }
    }
}
