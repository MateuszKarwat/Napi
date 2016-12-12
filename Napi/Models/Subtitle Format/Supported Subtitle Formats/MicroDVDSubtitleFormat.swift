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
    static let fileExtension = "sub"
    static let isTimeBased = false
    static let regexPattern = "\\{(\\d+)\\}\\{(\\d+)\\}(.+)"

    static func decode(_ aString: String) -> [Subtitle] {
        return MicroDVDSubtitleFormat.decode(aString, frameRate: 1.0)
    }

    static func decode(_ aString: String, frameRate: Double) -> [Subtitle] {
        var decodedSubtitles = [Subtitle]()

        self.enumerateMatches(in: aString) { match in
            let startNumber = Int(match.capturedSubstrings[0])
            let stopNumber = Int(match.capturedSubstrings[1])

            let newSubtitle = Subtitle(startTimestamp: startNumber!.frames(frameRate: frameRate),
                                       stopTimestamp: stopNumber!.frames(frameRate: frameRate),
                                       text: match.capturedSubstrings[2])

            decodedSubtitles.append(newSubtitle)
        }

        return decodedSubtitles
    }

    static func encode(_ subtitles: [Subtitle]) -> [String] {
        var encodedSubtitles = [String]()

        for subtitle in subtitles {
            let startTimestamp = subtitle.startTimestamp
            let stopTimestamp = subtitle.stopTimestamp

            var startValue: Int
            var stopValue: Int

            if startTimestamp.isFrameBased {
                startValue = startTimestamp.roundedValue(in: subtitle.startTimestamp.unit)
            } else {
                startValue = startTimestamp.numberOfFull(.frames(frameRate: 1.0))
            }

            if stopTimestamp.isFrameBased {
                stopValue = stopTimestamp.roundedValue(in: subtitle.stopTimestamp.unit)
            } else {
                stopValue = stopTimestamp.numberOfFull(.frames(frameRate: 1.0))
            }

            encodedSubtitles.append("{\(startValue)}{\(stopValue)}\(subtitle.text)")
        }

        return encodedSubtitles
    }
}
