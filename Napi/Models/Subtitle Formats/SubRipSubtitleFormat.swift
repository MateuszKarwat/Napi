//
//  SRTFormat.swift
//  Napi
//
//  Created by Mateusz Karwat on 05/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

/// SubRip Subtitle Format looks like this:
///
///     2
///     01:01:01,111 --> 02:02:02,222
///     First line of text.
///     Seconds line of text.
///     \n
struct SubRipSubtitleFormat: SubtitleFormat {
    var textNumber: UInt
    var startstamp: Timestamp?
    var stopstamp: Timestamp?
    var text: String
    static var regexPattern =
        "^(\\d++)$\\n" +
        "^(\\d{1,2}):(\\d{1,2}):(\\d{1,2}),(\\d{1,3})" +
        " --> " +
        "^(\\d{1,2}):(\\d{1,2}):(\\d{1,2}),(\\d{1,3})" +
        "(^.++$\\n)++" +
        "\\n"

    
    func stringValue() -> String? {
        if startstamp != nil && stopstamp != nil {
            return
                "\(textNumber)\n" +
                "\(stringFormatForSubtitleTime(startstamp!)) --> \(stringFormatForSubtitleTime(stopstamp!))\n" +
                "\(text)\n" +
                "\n"
        }
        return nil
    }
    
    func stringValueForTextStyle(style: TextStyle) -> String? {
        return nil
    }
    
    private func stringFormatForSubtitleTime(timestamp: Timestamp)  -> String {
        func numberToString(number: UInt, withLeadingZeros: Int) -> String {
            return String(format: "%0\(withLeadingZeros)d", number)
        }
        
        let minutes = timestamp - TS(hours: timestamp.numberOfFullHours)
        let seconds = minutes - TS(minutes: minutes.numberOfFullMinutes)
        let milliseconds = seconds - TS(seconds: seconds.numberOfFullSeconds)
        
        return
            "\(numberToString(timestamp.numberOfFullHours, withLeadingZeros: 2)):" +
            "\(numberToString(minutes.numberOfFullMinutes, withLeadingZeros: 2)):" +
            "\(numberToString(seconds.numberOfFullSeconds, withLeadingZeros: 2))," +
            "\(numberToString(milliseconds.milliseconds, withLeadingZeros: 3))"
        
    }
}