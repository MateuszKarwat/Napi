//
//  FrameCalculator.swift
//  Napi
//
//  Created by Mateusz Karwat on 07/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

struct SubtitleStampConverter {
    static func absoluteValueForType(type: SubtitleStampType, fromSubtitleStamp subtitleStamp: SubtitleStamp) -> UInt {
        let convertTypes = (from: subtitleStamp.type, to: type)
        let sourceAbsoluteValue = subtitleStamp.absoluteValue
        
        switch convertTypes {
        case (.TimeBased, .TimeBased):
            return sourceAbsoluteValue
            
        case (.TimeBased, .FrameBased(let FPS)):
            return SubtitleStampConverter.framesFromMilliseconds(sourceAbsoluteValue, andFrameRate: FPS)
            
        case (.FrameBased(let FPS), .TimeBased):
            return SubtitleStampConverter.millisecondsFromFrames(sourceAbsoluteValue, withFrameRate: FPS)
            
        case (.FrameBased(let fromFPS), .FrameBased(let toFPS)):
            let timeBasedValue = SubtitleStampConverter.millisecondsFromFrames(sourceAbsoluteValue, withFrameRate: fromFPS)
            return SubtitleStampConverter.framesFromMilliseconds(timeBasedValue, andFrameRate: toFPS)
        }
    }
    
    static func millisecondsFromFrames(frames: UInt, withFrameRate frameRate: Double) -> UInt {
        let calculatedValue = Double(frames) / frameRate * 1000
        return UInt(round(calculatedValue))
    }
    
    static func framesFromMilliseconds(milliseconds: UInt, andFrameRate frameRate: Double) -> UInt {
        let calculatedValue = Double(milliseconds) * frameRate / 1000
        return UInt(round(calculatedValue))
    }
}