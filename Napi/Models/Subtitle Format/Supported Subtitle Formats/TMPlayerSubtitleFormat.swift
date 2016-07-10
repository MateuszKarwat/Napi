//
//  TMPlayerSubtitleFormat.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

/// Represents TMPlayer Subtitle Format.
/// TMPlayer Subtitle Format looks like this:
///
///     01:12:33:First line of a text.|Seconds line of a text.
struct TMPlayerSubtitleFormat: SubtitleFormat {
    var startTimestamp: Timestamp?
    var stopTimestamp: Timestamp?
    
    var text: String
    
    static let regexPattern = "^(\\d{1,2}):(\\d{1,2}):(\\d{1,2}):(.++)$"

    static func decode(_ aString: String) -> TMPlayerSubtitleFormat? {
        // TODO: Implement
        return nil
    }
    
    func stringValue() -> String? {
        if let startTimestamp = startTimestamp {
            return "\(stringFormatForSubtitleTime(startTimestamp)):\(text)"
        }
        return nil
    }
}

extension TMPlayerSubtitleFormat {

    /// Returns `Timestamp` as a `String` that is compatible with TMPlayer format.
    private func stringFormatForSubtitleTime(_ timestamp: Timestamp)  -> String {
        let minutes = timestamp - TS(hours: timestamp.numberOfFullHours)
        let seconds = minutes - TS(minutes: minutes.numberOfFullMinutes)

        return
            "\(timestamp.numberOfFullHours.toString(leadingZeros: 2)):" +
            "\(minutes.numberOfFullMinutes.toString(leadingZeros: 2)):" +
            "\(seconds.numberOfFullSeconds.toString(leadingZeros: 2))"
    }
}
