//
//  SubtitleTime.swift
//  Napi
//
//  Created by Mateusz Karwat on 09/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Represents an interval in number of milliseconds.
struct Timestamp {

    /// Total number of milliseconds.
    var milliseconds: Int = 0

    /// Returns a number of full seconds calculated from `milliseconds`.
    var numberOfFullSeconds: Int { return milliseconds / 1000 }

    /// Returns a number of full minutes calculated from `milliseconds`.
    var numberOfFullMinutes: Int { return numberOfFullSeconds / 60 }

    /// Returns a number of full hours calculated from `milliseconds`.
    var numberOfFullHours: Int { return numberOfFullMinutes / 60 }

    /// Creates a new instance with specified number of `milliseconds.`
    init(milliseconds: Int) { self.milliseconds = max(0, milliseconds) }

    /// Creates a new instance with number of `milliseconds`
    /// calculated based on the given number of `seconds`
    init(seconds: Int) { self.init(milliseconds: seconds * 1000) }

    /// Creates a new instance with number of `milliseconds`
    /// calculated based on the given number of `minutes`.
    init(minutes: Int) { self.init(seconds: minutes * 60 ) }

    /// Creates a new instance with number of `milliseconds`
    /// calculated based on the given number of `hours`.
    init(hours: Int) { self.init(minutes: hours * 60) }
}

// MARK: Frame based support

extension Timestamp {

    /// Creates a new instance with number of milliseconds
    /// calculated based on the given number of frames
    /// in a specific frame rate.
    init(frames: Int, frameRate: Double) {
        let calculatedValue = Double(max(0, frames)) / max(0.0, frameRate) * 1000
        milliseconds = Int(round(calculatedValue))
    }

    /// Returns number of frames with specified frame rate.
    ///
    /// - Parameter withFrameRate: Specifies to which frame rate
    ///   current `milliseconds` should be converted.
    ///
    /// - Returns: Number of frames in specific frame rate based on current
    ///   number of `milliseconds`.
    func numberOfFrames(withFrameRate frameRate: Double) -> Int {
        let calculatedValue = Double(milliseconds) * frameRate / 1000
        return Int(round(calculatedValue))
    }
}

// MARK: Arithmetic Operators

typealias TS = Timestamp

func +(lhs: TS, rhs: TS) -> TS {
    let sum = lhs.milliseconds + rhs.milliseconds
    return TS(milliseconds: sum)
}

func -(lhs: TS, rhs: TS) -> TS {
    if lhs.milliseconds > rhs.milliseconds {
        return TS(milliseconds: lhs.milliseconds - rhs.milliseconds)
    } else {

        return TS(milliseconds: 0)
    }
}
