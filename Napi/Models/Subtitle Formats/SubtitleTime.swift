//
//  SubtitleTime.swift
//  Napi
//
//  Created by Mateusz Karwat on 09/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

typealias ST = SubtitleTime

struct SubtitleTime {
    var milliseconds: UInt = 0
    
    var fullSeconds: UInt { return milliseconds / 1000 }
    var fullMinutes: UInt { return fullSeconds / 60 }
    var fullHours: UInt { return fullMinutes / 60 }
    
    init(milliseconds: UInt) { self.milliseconds = milliseconds }
    init(seconds: UInt) { milliseconds = seconds * 1000 }
    init(minutes: UInt) { milliseconds = minutes * 60 * 1000 }
    init(hours: UInt) { milliseconds = hours * 60 * 60 * 1000 }
}

func +(left: ST, right: ST) -> ST {
    let sum = left.milliseconds + right.milliseconds
    return ST(milliseconds: sum)
}

func -(left: ST, right: ST) -> ST {
    if left.milliseconds > right.milliseconds {
        return ST(milliseconds: left.milliseconds - right.milliseconds)
    } else {
        return ST(milliseconds: 0)
    }
}