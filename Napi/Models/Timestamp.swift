//
//  SubtitleTime.swift
//  Napi
//
//  Created by Mateusz Karwat on 09/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

struct Timestamp {
    var milliseconds: Int = 0
    
    var numberOfFullSeconds: Int { return milliseconds / 1000 }
    var numberOfFullMinutes: Int { return numberOfFullSeconds / 60 }
    var numberOfFullHours: Int { return numberOfFullMinutes / 60 }
    
    init(milliseconds: Int) { self.milliseconds = milliseconds }
    init(seconds: Int) { milliseconds = seconds * 1000 }
    init(minutes: Int) { milliseconds = minutes * 60 * 1000 }
    init(hours: Int) { milliseconds = hours * 60 * 60 * 1000 }
}

// Support for frame based stamps
extension Timestamp {
    init(frames: Int, frameRate: Double) {
        let calculatedValue = Double(frames) / frameRate * 1000
        milliseconds = Int(round(calculatedValue))
    }
    
    func numberOfFrames(withFrameRate frameRate: Double) -> Int {
        let calculatedValue = Double(milliseconds) * frameRate / 1000
        return Int(round(calculatedValue))
    }
}

// MARK: Arithmetic Operators

typealias TS = Timestamp

func +(left: TS, right: TS) -> TS {
    let sum = left.milliseconds + right.milliseconds
    return TS(milliseconds: sum)
}

func -(left: TS, right: TS) -> TS {
    if left.milliseconds > right.milliseconds {
        return TS(milliseconds: left.milliseconds - right.milliseconds)
    } else {
        
        return TS(milliseconds: 0)
    }
}