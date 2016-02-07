//
//  FrameCalculator.swift
//  Napi
//
//  Created by Mateusz Karwat on 07/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

struct FrameCalculator {
    
    static func framesToMilliseconds(frames: UInt, withFrameRate frameRate: Double) -> UInt {
        let calculatedValue = Double(frames) / frameRate * 1000
        return UInt(round(calculatedValue))
    }
    
    static func millisecondsToFrames(milliseconds: UInt, withFrameRate frameRate: Double) -> UInt {
        let calculatedValue = Double(milliseconds) * frameRate / 1000
        return UInt(round(calculatedValue))
    }
    
}