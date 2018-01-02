//
//  Interpreter.swift
//  CHIP8
//
//  Created by Alin Baciu on 16/12/2017.
//  Copyright © 2017 Alin Baciu. All rights reserved.
//

import Cocoa

class Interpreter: NSObject {
    var spriteFiller = SpriteFiller()
    var spriteLocations = [UInt16]()
    var ram = [UInt8]()
    var rom = [UInt8]()
    var registers:[UInt8] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var I:UInt16 = 0
    var PC:UInt16 = 0
    var stack:[UInt16] = []
    var DT:UInt8 = 0
    var ST:UInt8 = 0
    let VF = 15
    var vram = [UInt8](repeating:0, count:64*32)
    var keysPressed:[UInt8: Bool] = [:]
    
    var romLoaded = false
    
    fileprivate var currentRom: URL? = nil
    
    func start(file:URL) -> Bool {
        if let data = NSData.init(contentsOf: file) {
            var buffer = [UInt8](repeating:0, count:data.length)
            data.getBytes(&buffer, length: data.length)
            rom = buffer
            setupRam()
            clearVram()
            PC = 512
            romLoaded = true
            currentRom = file
            return true
        }
        return false
    }
    
    func resetRom() {
        if let url = currentRom {
            _ = self.start(file: url)
        }
    }
    
    func setupRam() {
        spriteLocations = spriteFiller.fillRamWithSprites()
        ram = spriteFiller.ram
        while ram.count < 512 {
            ram.append(UInt8(0))
        }
        ram = ram + rom
        while ram.count < 4095 {
            ram.append(UInt8(0))
        }
    }
    
    func runRom() {
        while PC < ram.count {
            step()
        }
    }
    
    func canRun() -> Bool {
        return PC < ram.count
    }
    
    func step() {
        let byte1 = ram[Int(PC)]
        let byte2 = ram[Int(PC)+1]
        let opcode = UInt16(byte1) << 8 | UInt16(byte2)
        let instruction = String.init(format: "%X", opcode)
        //            print(instruction)
        let instr = (opcode & 0xF000) >> 12
        var shouldIncrementPC = true
        switch instr {
        case 0x0:
            switch byte2 {
                
            case 0xE0:
                self.clearVram()
                break
                
            case 0xEE:
                PC = stack.removeLast()
                break
                
            default:
                print("unknown \(instruction)")
            }
            break
            
        case 0x1:
            PC = opcode & 0x0FFF
            shouldIncrementPC = false
            break
            
        case 0x2:
            stack.append(PC)
            PC = opcode & 0x0FFF
            shouldIncrementPC = false
            break
            
        case 0x3:
            let reg = Int(byte1 & 0x0F)
            let value = registers[reg]
            if value == byte2 {
                PC += 2
            }
            break
            
        case 0x4:
            let reg = Int(byte1 & 0x0F)
            let value = registers[reg]
            if value != byte2 {
                PC += 2
            }
            break
            
        case 0x5:
            let reg1 = Int(byte1 & 0x0F)
            let value1 = registers[reg1]
            
            let reg2 = Int(byte2 & 0xF0) >> 4
            let value2 = registers[reg2]
            if value1 == value2 {
                PC += 2
            }
            break
            
        case 0x6:
            let reg = Int(byte1 & 0x0F)
            self.registers[reg] = byte2
            break
            
        case 0x7:
            let reg = Int(byte1 & 0x0F)
            let value = registers[reg]
            let(output, _) = value.addingReportingOverflow(byte2)
            registers[reg] = output
            break
            
        case 0x8:
            let byteToCheck = (byte2 & 0x0F)
            
            let reg1 = Int(byte1 & 0x0F)
            let value1 = registers[reg1]
            
            let reg2 = Int(byte2 & 0xF0) >> 4
            let value2 = registers[reg2]
            
            switch byteToCheck {
            case 0x0:
                registers[reg1] = value2
                break;
                
            case 0x1:
                registers[reg1] = value1 | value2
                break;
                
            case 0x2:
                registers[reg1] = value1 & value2
                break
                
            case 0x3:
                registers[reg1] = value1 ^ value2
                break
                
            case 0x4:
                registers[reg1] = self.addRegistries(Vx: reg1, Vy: reg2)
                break
                
            case 0x5:
                registers[reg1] = self.subtractRegistries(Vx: reg1, Vy: reg2)
                break
                
            case 0x6:
                registers[VF] = value1 & 0b00000001
                registers[reg1] = value1 >> 1
                break
                
            case 0x7:
                registers[reg1] = self.subtractRegistries(Vx: reg2, Vy: reg1)
                break
                
            case 0xE:
                registers[VF] = (value1 & 0b10000000) >> 7
                registers[reg1] = value1 << 1
                break
                
            default:
                print("unknown \(instruction)")
            }
            break;
            
        case 0x9:
            let reg1 = Int(byte1 & 0x0F)
            let value1 = registers[reg1]
            
            let reg2 = Int(byte2 & 0xF0) >> 4
            let value2 = registers[reg2]
            if value1 != value2 {
                PC += 2
            }
            break
            
        case 0xA:
            I = (UInt16(byte1 & 0x0F)) << 8
            I = I | UInt16(byte2)
            break
            
        case 0xC:
            let reg = Int(byte1 & 0x0f)
            let rand = UInt8(arc4random_uniform(256))
            registers[reg] = rand & byte2
            break
            
        case 0xD:
            let reg1 = Int(byte1 & 0x0F)
            let value1 = Int(registers[reg1])
            let reg2 = Int(byte2 & 0xF0) >> 4
            let value2 = Int(registers[reg2])
            let bytes = Int(byte2 & 0x0F)
            self.draw(x: value1, y: value2, bytes: bytes)
        case 0xE:
            switch byte2 {
                
            case 0x9E:
                let reg = Int(byte1 & 0x0f)
                let value = registers[reg]
                if keysPressed[value] == true {
                    PC += 2
                }
                break
                
            case 0xA1:
                let reg = Int(byte1 & 0x0f)
                let value = registers[reg]
                if keysPressed[value] != true {
                    PC += 2
                }
                break
                
            default:
                print("unknown \(instruction)")
            }
            break
            
        case 0xF:
            switch byte2 {
                
            case 0x07:
                let reg = Int(byte1 & 0x0F)
                registers[reg] = DT
                break
                
            case 0x0A:
                shouldIncrementPC = false
                
                let reg = Int(byte1 & 0x0F)
                for i:UInt8 in 0x0...0xF {
                    if keysPressed[i] == true {
                        shouldIncrementPC = true
                        registers[reg] = i
                        break
                    }
                }
                break
                
            case 0x15:
                let reg = Int(byte1 & 0x0F)
                let value = registers[reg]
                DT = value
                break
                
            case 0x18:
                let reg = Int(byte1 & 0x0F)
                let value = registers[reg]
                ST = value
                break
                
            case 0x1E:
                let reg = Int(byte1 & 0x0F)
                let value = registers[reg]
                I = I + UInt16(value)
                break
                
            case 0x29:
                let reg = Int(byte1 & 0x0F)
                let value = registers[reg]
                let spriteLocation = spriteLocations[Int(value)]
                I = spriteLocation
                break
                
            case 0x33:
                let reg = Int(byte1 & 0x0F)
                let value = registers[reg]
                ram[Int(I)] = value / 100
                ram[Int(I+1)] = (value % 100) / 10
                ram[Int(I+2)] = value % 10
                break
                
            case 0x55:
                let reg = Int(byte1 & 0x0F)
                let initialI = I
                for index in 0...reg {
                    ram[Int(I)] = registers[index]
                    I+=1
                }
                I = initialI
                break
                
            case 0x65:
                let reg = Int(byte1 & 0x0F)
                let initialI = I
                for index in 0...reg {
                    registers[index] = ram[Int(I)]
                    I+=1
                }
                I = initialI
                break
            default:
                print("unknown \(instruction)")
            }
            break
            
            
        default:
            print("unimplemented")
        }
        if shouldIncrementPC {
            PC = PC+2
        }
    }
}
