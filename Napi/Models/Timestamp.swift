//
//  SubtitleTime.swift
//  Napi
//
//  Created by Mateusz Karwat on 09/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

typealias TS = Timestamp

struct Timestamp {
    var milliseconds: UInt = 0
    
    var numberOfFullSeconds: UInt { return milliseconds / 1000 }
    var numberOfFullMinutes: UInt { return numberOfFullSeconds / 60 }
    var numberOfFullHours: UInt { return numberOfFullMinutes / 60 }
    
    init(milliseconds: UInt) { self.milliseconds = milliseconds }
    init(seconds: UInt) { milliseconds = seconds * 1000 }
    init(minutes: UInt) { milliseconds = minutes * 60 * 1000 }
    init(hours: UInt) { milliseconds = hours * 60 * 60 * 1000 }
}

extension Timestamp: SubtitleStamp {
    var type: SubtitleStampType {
        return .TimeBased
    }
    
    var absoluteValue: UInt {
        return milliseconds
    }
}

// MARK: Arithmetic Operators

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