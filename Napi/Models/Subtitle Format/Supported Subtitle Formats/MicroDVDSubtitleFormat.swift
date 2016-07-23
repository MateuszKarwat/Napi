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
    var frameRate: Double
    var startTimestamp: Timestamp?
    var stopTimestamp: Timestamp?
    
    var text: String
    
    static let regexPattern = "\\{(\\d+)\\}\\{(\\d+)\\}(.+)"

    static func decode(_ aString: String) -> MicroDVDSubtitleFormat? {
        return MicroDVDSubtitleFormat.decode(aString, frameRate: 23.976)
    }

    static func decode(_ aString: String, frameRate: Double) -> MicroDVDSubtitleFormat? {
        guard
            let substrings = MicroDVDSubtitleFormat.capturedSubstrings(from: aString),
            let startStamp = Int(substrings[0]),
            let stopStamp = Int(substrings[1]),
            substrings.count == 3 else {
                return nil
        }

        return MicroDVDSubtitleFormat(frameRate: frameRate,
                                      startTimestamp: TS(frames: startStamp, frameRate: frameRate),
                                      stopTimestamp: TS(frames: stopStamp, frameRate: frameRate),
                                      text: substrings[2])
    }
    
    func stringValue() -> String? {
        if let startValue = startTimestamp?.numberOfFrames(withFrameRate: frameRate),
            let stopValue = stopTimestamp?.numberOfFrames(withFrameRate: frameRate) {
            return "{\(startValue)}{\(stopValue)}\(text)"
        }
        return nil
    }
}
