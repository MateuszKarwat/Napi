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
    var startTimestamp: Timestamp?
    var stopTimestamp: Timestamp?
    
    var text: String

    static let regexPattern = "\\[(\\d+)\\]\\[(\\d+)\\](.+)"

    static func decode(_ aString: String) -> MPL2SubtitleFormat? {
        let regex = try! RegularExpression(pattern: MPL2SubtitleFormat.regexPattern, options: [])
        let range = NSRange(location: 0, length: aString.characters.count)

        guard
            let match = regex.firstMatch(in: aString, options: [], range: range),
            let startStamp = Int(aString[match.range(at: 1)]),
            let stopStamp = Int(aString[match.range(at: 2)]) else {
                return nil
        }

        return MPL2SubtitleFormat(startTimestamp: TS(milliseconds: startStamp * 100),
                                  stopTimestamp: TS(milliseconds: stopStamp * 100),
                                  text: aString[match.range(at: 3)])
    }

    func stringValue() -> String? {
        if let startValue = startTimestamp?.milliseconds, stopValue = stopTimestamp?.milliseconds {
            return "[\(startValue / 100)][\(stopValue / 100)]\(text)"
        }
        return nil
    }
}
