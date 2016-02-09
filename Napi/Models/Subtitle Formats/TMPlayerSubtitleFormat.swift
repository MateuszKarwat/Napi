//
//  TMPlayerSubtitleFormat.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

/// Struct to store all data used by TMP subtitle format.
struct TMPlayerSubtitleFormat: TimeBasedSubtitleFormat {
    var startTime: SubtitleTime
    var linesOfText: [String]
    var linesSeparator: String = "|"
    
    init(startTime: SubtitleTime, linesOfText: [String]) {
        self.startTime = startTime
        self.linesOfText = linesOfText
    }
    
    /// Returns a string which looks like this: 01:12:33:Line of text.
    func stringFormat() -> String {
        return "\(stringFormatForSubtitleTime(startTime)):\(linesOfText.joinWithSeparator(linesSeparator))"
    }
    
    private func stringFormatForSubtitleTime(subtitleTime: SubtitleTime)  -> String {
        func numberToString(number: UInt, withLeadingZeros: Int) -> String {
            return String(format: "%0\(withLeadingZeros)d", number)
        }
        
        let minutes = subtitleTime - ST(hours: subtitleTime.fullHours)
        let seconds = minutes - ST(minutes: minutes.fullMinutes)
        
        return
            "\(numberToString(subtitleTime.fullHours, withLeadingZeros: 2)):" +
            "\(numberToString(minutes.fullMinutes, withLeadingZeros: 2)):" +
            "\(numberToString(seconds.fullSeconds, withLeadingZeros: 2))"
    }
}