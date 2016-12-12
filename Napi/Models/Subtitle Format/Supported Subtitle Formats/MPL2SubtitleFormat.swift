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
    static let fileExtension = "txt"
    static let isTimeBased = true
    static let regexPattern = "\\[(\\d+)\\]\\[(\\d+)\\](.+)"

    static func decode(_ aString: String) -> [Subtitle] {
        var decodedSubtitles = [Subtitle]()

        self.enumerateMatches(in: aString) { match in
            let startNumber = Int(match.capturedSubstrings[0])
            let stopNumber = Int(match.capturedSubstrings[1])

            let newSubtitle = Subtitle(startTimestamp: startNumber!.deciseconds,
                                       stopTimestamp: stopNumber!.deciseconds,
                                       text: match.capturedSubstrings[2])

            decodedSubtitles.append(newSubtitle)
        }

        return decodedSubtitles
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
