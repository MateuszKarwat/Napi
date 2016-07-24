//
//  Int+Timestamp.swift
//  Napi
//
//  Created by Mateusz Karwat on 24/07/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

extension Int {
    var milliseconds: Timestamp {
        return Timestamp(value: self, unit: .milliseconds)
    }

    var deciseconds: Timestamp {
        return Timestamp(value: self, unit: .deciseconds)
    }

    var seconds: Timestamp {
        return Timestamp(value: self, unit: .seconds)
    }

    var minutes: Timestamp {
        return Timestamp(value: self, unit: .minutes)
    }

    var hours: Timestamp {
        return Timestamp(value: self, unit: .hours)
    }

    func framesPerSecond(frameRate: Double) -> Timestamp {
        return Timestamp(value: self, unit: .framesPerSecond(frameRate: frameRate))
    }
}
