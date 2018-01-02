//
//  Interpreter+Math.swift
//  CHIP8
//
//  Created by Alin Baciu on 17/12/2017.
//  Copyright © 2017 Alin Baciu. All rights reserved.
//

import Cocoa

extension Interpreter {
    func addRegistries(Vx:Int, Vy:Int) -> UInt8 {
        registers[VF] = 0
        let R1 = UInt8(registers[Vx])
        let R2 = UInt8(registers[Vy])
        let(output,overflow) = R1.addingReportingOverflow(R2)
        if overflow {
            registers[VF] = 1
        }
        return output
    }
    
    func subtractRegistries(Vx:Int, Vy:Int) -> UInt8 {
        registers[VF] = 0
        let R1 = UInt8(registers[Vx])
        let R2 = UInt8(registers[Vy])
        let(output,overflow) = R1.subtractingReportingOverflow(R2)
        if !overflow {
            registers[VF] = 1
        }
        return output
    }
}
