//
//  SRTFormat.swift
//  Napi
//
//  Created by Mateusz Karwat on 05/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

/// Struct to store all data required by SubRip subtitle format.
struct SubRipSubtitleFormat: TimeBasedSubtitleFormat {
    let textNumber: UInt
    let startTimeCode: TimeCodeFormat
    let stopTimeCode: TimeCodeFormat?
    let linesOfText: [String]
    let linesSeparator = "\n"
    
    init(textNumber: UInt, startTimeCode: SubRipTimeCode, stopTimeCode: SubRipTimeCode, linesOfText: [String]) {
        self.textNumber = textNumber
        self.startTimeCode = startTimeCode
        self.stopTimeCode = stopTimeCode
        self.linesOfText = linesOfText
    }
    
    func formattedString() -> String {
        return "\(textNumber)\n" +
            "\(startTimeCode.formattedString()) --> \(stopTimeCode!.formattedString())\n" +
            "\(linesOfText.joinWithSeparator(linesSeparator))\n" +
            "\n"
    }
}

/// Struct to store time code used in SubRip subtitle format.
struct SubRipTimeCode: TimeCodeFormat {
    let hours: UInt
    let minutes: UInt
    let seconds: UInt
    let milliseconds: UInt
    var totalNumberOfMilliseconds: UInt {
        let totalMinutes = hours * 60 + minutes
        let totalSeconds = totalMinutes * 60 + seconds
        let totalmilliseconds = totalSeconds * 1000 + milliseconds
        return totalmilliseconds
    }
    
    init(totalNumberOfMilliseconds: UInt) {
        let numberOfSeconds = totalNumberOfMilliseconds / 1000
        let numberOfMinutes = numberOfSeconds / 60
        let numberOfHours = numberOfMinutes / 60
        
        self.milliseconds = totalNumberOfMilliseconds - (numberOfSeconds * 1000)
        self.seconds = numberOfSeconds - (numberOfMinutes * 60)
        self.minutes = numberOfMinutes - (numberOfHours * 60)
        self.hours = numberOfHours
    }
    
    init?(hours: UInt, minutes: UInt, seconds: UInt, milliseconds: UInt) {
        // If minutes, seconds or milliseconds are higher than its max clock's value,
        // nil is returned.
        if !(0...59 ~= minutes) || !(0...59 ~= seconds) || !(0...999 ~= milliseconds) {
            return nil
        }
        
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        self.milliseconds = milliseconds
    }
    
    /// Returns a string which looks like this:
    ///     SubRipTimeCode(hours: 1, minutes: 2, seconds: 3, milliseconds: 44).formattedString() // 01:02:03,044
    func formattedString() -> String {
        func numberToString(number: UInt, withLeadingZeros: Int) -> String {
            return String(format: "%0\(withLeadingZeros)d", number)
        }
        
        return "\(numberToString(hours, withLeadingZeros: 2)):" +
            "\(numberToString(minutes, withLeadingZeros: 2)):" +
            "\(numberToString(seconds, withLeadingZeros: 2))," +
            "\(numberToString(milliseconds, withLeadingZeros: 3))"
    }
}