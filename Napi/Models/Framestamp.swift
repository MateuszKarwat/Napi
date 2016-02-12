//
//  Framestamp.swift
//  Napi
//
//  Created by Mateusz Karwat on 12/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

struct Framestamp {
    var frames: UInt = 0
    var frameRate: Double = 0.0
}

extension Framestamp: SubtitleStamp {
    var type: SubtitleStampType {
        return .FrameBased(FPS: frameRate)
    }
    
    var absoluteValue: UInt {
        return frames
    }
}