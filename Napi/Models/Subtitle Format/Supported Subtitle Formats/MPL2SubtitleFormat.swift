//
//  MPL2Format.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Represents MPL2 Subtitle Format.
/// MPL2 Subtitle Format looks like this:
///
///     [111][222]First line of a text.|Seconds line of a text.
struct MPL2SubtitleFormat: SubtitleFormat {
    static let regexPattern = "\\[(\\d+)\\]\\[(\\d+)\\](.+)"

    static func decode(_ aString: String) -> Subtitle? {
        guard
            let substrings = MPL2SubtitleFormat.capturedSubstrings(from: aString),
            let startStamp = Int(substrings[0])?.deciseconds,
            let stopStamp = Int(substrings[1])?.deciseconds,
            substrings.count == 3 else {
                return nil
        }

        return Subtitle(startTimestamp: startStamp,
                        stopTimestamp: stopStamp,
                        text: substrings[2])
    }

    static func encode(_ subtitles: [Subtitle]) -> [String] {
        var encodedSubtitles = [String]()

        for subtitle in subtitles {
            encodedSubtitles.append(
                "[\(subtitle.startTimestamp.roundedValue(in: .deciseconds))]" +
                "[\(subtitle.stopTimestamp.roundedValue(in: .deciseconds))]" +
                "\(subtitle.text)")
        }

        return encodedSubtitles
    }
}
