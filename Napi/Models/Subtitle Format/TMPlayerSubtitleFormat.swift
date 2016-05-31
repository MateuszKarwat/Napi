//
//  TMPlayerSubtitleFormat.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

/// TMPPlayer Subtitle Format looks like this:
///
///     01:12:33:First line of text.|Seconds line of text.
struct TMPlayerSubtitleFormat: SubtitleFormat {
    var startTimestamp: Timestamp?
    var stopTimestamp: Timestamp?
    var text: String
    static let regexPattern = "^(\\d{1,2}):(\\d{1,2}):(\\d{1,2}):(.++)$"
    
    func stringValue() -> String? {
        if startTimestamp != nil {
            return "\(stringFormatForSubtitleTime(startTimestamp!)):\(text)"
        }
        return nil
    }
    
    private func stringFormatForSubtitleTime(timestamp: Timestamp)  -> String {
        func numberToString(number: Int, withLeadingZeros: Int) -> String {
            return String(format: "%0\(withLeadingZeros)d", number)
        }
        
        let minutes = timestamp - TS(hours: timestamp.numberOfFullHours)
        let seconds = minutes - TS(minutes: minutes.numberOfFullMinutes)
        
        return
            "\(numberToString(timestamp.numberOfFullHours, withLeadingZeros: 2)):" +
            "\(numberToString(minutes.numberOfFullMinutes, withLeadingZeros: 2)):" +
            "\(numberToString(seconds.numberOfFullSeconds, withLeadingZeros: 2))"
    }
}