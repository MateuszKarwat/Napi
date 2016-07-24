//
//  TMPlayerSubtitleFormat.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Represents TMPlayer Subtitle Format.
/// TMPlayer Subtitle Format looks like this:
///
///     01:12:33:First line of a text.|Seconds line of a text.
struct TMPlayerSubtitleFormat: SubtitleFormat {
    var startTimestamp: Timestamp
    var stopTimestamp: Timestamp
    
    var text: String
    
    static let regexPattern = "(\\d{1,2}):(\\d{1,2}):(\\d{1,2}):(.+)"

    static func decode(_ aString: String) -> TMPlayerSubtitleFormat? {
        guard
            let substrings = TMPlayerSubtitleFormat.capturedSubstrings(from: aString),
            let hours = Int(substrings[0])?.hours,
            let minutes = Int(substrings[1])?.minutes,
            let seconds = Int(substrings[2])?.seconds,
            substrings.count == 4 else {
                return nil
        }

        let timestamp = hours + minutes + seconds

        return TMPlayerSubtitleFormat(startTimestamp: timestamp,
                                      stopTimestamp: timestamp + 5.seconds,
                                      text: substrings[3])
    }
    
    func stringValue() -> String {
        return "\(stringFormatForSubtitleTime(startTimestamp)):\(text)"
    }
}

extension TMPlayerSubtitleFormat {

    /// Returns `Timestamp` as a `String` that is compatible with TMPlayer format.
    private func stringFormatForSubtitleTime(_ timestamp: Timestamp)  -> String {
        let minutes = timestamp - Timestamp(value: timestamp.numberOfFull(.hours), unit: .hours)
        let seconds = minutes - Timestamp(value: minutes.numberOfFull(.minutes), unit: .minutes)

        return
            "\(timestamp.numberOfFull(.hours).toString(leadingZeros: 2)):" +
            "\(minutes.numberOfFull(.minutes).toString(leadingZeros: 2)):" +
            "\(seconds.numberOfFull(.seconds).toString(leadingZeros: 2))"
    }
}
