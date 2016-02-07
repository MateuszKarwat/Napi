//
//  TMPlayerSubtitleFormat.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

/// Struct to store all data used by TMP subtitle format.
struct TMPlayerSubtitleFormat: TimeBasedSubtitleFormat {
    var startTimeCode: TimeCodeFormat
    var linesOfText: [String]
    var linesSeparator: String = "|"
    
    init(startTimeCode: TMPlayerTimeCode, linesOfText: [String]) {
        self.startTimeCode = startTimeCode
        self.linesOfText = linesOfText
    }
    
    /// Returns a string which looks like this: 01:12:33:Line of text.
    func formattedString() -> String {
        return "\(startTimeCode.formattedString()):\(linesOfText.joinWithSeparator(linesSeparator))"
    }
}

/// Struct which stores all time units used by TMP subtitle format.
struct TMPlayerTimeCode: TimeCodeFormat {
    let hours: UInt
    let minutes: UInt
    let seconds: UInt
    var totalNumberOfMilliseconds: UInt {
        let totalMinutes = hours * 60 + minutes
        let totalSeconds = totalMinutes * 60 + seconds
        return totalSeconds * 1000
    }
    
    init(totalNumberOfMilliseconds: UInt) {
        let numberOfSeconds = totalNumberOfMilliseconds / 1000
        let numberOfMinutes = numberOfSeconds / 60
        let numberOfHours = numberOfMinutes / 60
        
        self.seconds = numberOfSeconds - (numberOfMinutes * 60)
        self.minutes = numberOfMinutes - (numberOfHours * 60)
        self.hours = numberOfHours
    }
    
    init?(hours: UInt, minutes: UInt, seconds: UInt) {
        // If minutes or seconds are higher than its max clock's value,
        // nil is returned.
        if !(0...59 ~= minutes) || !(0...59 ~= seconds) {
            return nil
        }
        
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }
    
    /// Returns a string which looks like this:
    ///     TMPlayerTimeCode(hours: 1, minutes: 2, seconds: 3).formattedString() // 01:02:03
    func formattedString() -> String {
        func numberToString(number: UInt, withLeadingZeros: Int) -> String {
            return String(format: "%0\(withLeadingZeros)d", number)
        }
        
        return "\(numberToString(hours, withLeadingZeros: 2)):" +
            "\(numberToString(minutes, withLeadingZeros: 2)):" +
            "\(numberToString(seconds, withLeadingZeros: 2))"
    }
}