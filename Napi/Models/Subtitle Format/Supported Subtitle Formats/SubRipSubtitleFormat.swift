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
    var textNumber: Int
    var startTimestamp: Timestamp?
    var stopTimestamp: Timestamp?
    
    var text: String
    static let regexPattern =
        "^(\\d++)$\\n" +
        "^(\\d{1,2}):(\\d{1,2}):(\\d{1,2}),(\\d{1,3})" +
        " --> " +
        "^(\\d{1,2}):(\\d{1,2}):(\\d{1,2}),(\\d{1,3})" +
        "(^.++$\\n)++" +
        "\\n"
    
    func stringValue() -> String? {
        if startTimestamp != nil && stopTimestamp != nil {
            return
                "\(textNumber)\n" +
                "\(stringFormatForSubtitleTime(startTimestamp!)) --> \(stringFormatForSubtitleTime(stopTimestamp!))\n" +
                "\(text)\n" +
                "\n"
        }
        return nil
    }
    
    private func stringFormatForSubtitleTime(_ timestamp: Timestamp)  -> String {
        let minutes = timestamp - TS(hours: timestamp.numberOfFullHours)
        let seconds = minutes - TS(minutes: minutes.numberOfFullMinutes)
        let milliseconds = seconds - TS(seconds: seconds.numberOfFullSeconds)
        
        return
            "\(timestamp.numberOfFullHours.toString(withLeadingZeros: 2)):" +
            "\(minutes.numberOfFullMinutes.toString(withLeadingZeros: 2)):" +
            "\(seconds.numberOfFullSeconds.toString(withLeadingZeros: 2))," +
            "\(milliseconds.milliseconds.toString(withLeadingZeros: 3))"
        
    }
}
