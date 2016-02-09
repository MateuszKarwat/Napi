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
    let startTime: SubtitleTime
    let stopTime: SubtitleTime
    let linesOfText: [String]
    let linesSeparator = "\n"
    
    init(textNumber: UInt, startTime: SubtitleTime, stopTime: SubtitleTime, linesOfText: [String]) {
        self.textNumber = textNumber
        self.startTime = startTime
        self.stopTime = stopTime
        self.linesOfText = linesOfText
    }
    
    func stringFormat() -> String {
        return "\(textNumber)\n" +
            "\(stringFormatForSubtitleTime(startTime)) --> \(stringFormatForSubtitleTime(stopTime))\n" +
            "\(linesOfText.joinWithSeparator(linesSeparator))\n" +
            "\n"
    }
    
    private func stringFormatForSubtitleTime(subtitleTime: SubtitleTime)  -> String {
        func numberToString(number: UInt, withLeadingZeros: Int) -> String {
            return String(format: "%0\(withLeadingZeros)d", number)
        }
        
        let minutes = subtitleTime - ST(hours: subtitleTime.fullHours)
        let seconds = minutes - ST(minutes: minutes.fullMinutes)
        let milliseconds = seconds - ST(seconds: seconds.fullSeconds)
        
        return
            "\(numberToString(subtitleTime.fullHours, withLeadingZeros: 2)):" +
            "\(numberToString(minutes.fullMinutes, withLeadingZeros: 2)):" +
            "\(numberToString(seconds.fullSeconds, withLeadingZeros: 2))," +
            "\(numberToString(milliseconds.milliseconds, withLeadingZeros: 3))"
        
    }
}