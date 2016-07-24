//
//  MicroDVDSubtitleFormat.swift
//  Napi
//
//  Created by Mateusz Karwat on 07/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Represents MicroDVD Subtitle Format.
/// MicroDVD Subtitle Format looks like this:
///
///     {111}{222}First line of a text.|Seconds line of a text.
struct MicroDVDSubtitleFormat: SubtitleFormat {
    var startTimestamp: Timestamp
    var stopTimestamp: Timestamp
    
    var text: String
    
    static let regexPattern = "\\{(\\d+)\\}\\{(\\d+)\\}(.+)"

    static func decode(_ aString: String) -> MicroDVDSubtitleFormat? {
        return MicroDVDSubtitleFormat.decode(aString, frameRate: 23.976)
    }

    static func decode(_ aString: String, frameRate: Double) -> MicroDVDSubtitleFormat? {
        guard
            let substrings = MicroDVDSubtitleFormat.capturedSubstrings(from: aString),
            let startStamp = Int(substrings[0])?.framesPerSecond(frameRate: frameRate),
            let stopStamp = Int(substrings[1])?.framesPerSecond(frameRate: frameRate),
            substrings.count == 3 else {
                return nil
        }

        return MicroDVDSubtitleFormat(startTimestamp: startStamp,
                                      stopTimestamp: stopStamp,
                                      text: substrings[2])
    }
    
    func stringValue() -> String {
        var startValue: Int
        var stopValue: Int

        if case .framesPerSecond(frameRate: _) = startTimestamp.unit {
            startValue = startTimestamp.numberOfFull(startTimestamp.unit)
        } else {
            startValue = startTimestamp.roundedValue(in: .framesPerSecond(frameRate: 23.976))
        }

        if case .framesPerSecond(frameRate: _) = stopTimestamp.unit {
            stopValue = stopTimestamp.numberOfFull(startTimestamp.unit)
        } else {
            stopValue = stopTimestamp.roundedValue(in: .framesPerSecond(frameRate: 23.976))
        }

        return "{\(startValue)}{\(stopValue)}\(text)"
    }
}
