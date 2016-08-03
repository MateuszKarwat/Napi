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
    static let fileExtension = "txt"
    static let isTimeBased = true
    static let regexPattern = "(\\d{1,2}):(\\d{1,2}):(\\d{1,2}):(.+)"

    static func decode(_ aString: String) -> [Subtitle] {
        var decodedSubtitles = [Subtitle]()

        self.enumerateMatches(in: aString) { match in
            let hours = Int(match.capturedSubstrings[0])!.hours
            let minutes = Int(match.capturedSubstrings[1])!.minutes
            let seconds = Int(match.capturedSubstrings[2])!.seconds

            let timestamp = hours + minutes + seconds

            let newSubtitle = Subtitle(startTimestamp: timestamp,
                                       stopTimestamp: timestamp + 5.seconds,
                                       text: match.capturedSubstrings[3])

            decodedSubtitles.append(newSubtitle)
        }

        return decodedSubtitles
    }

    static func encode(_ subtitles: [Subtitle]) -> [String] {
        var encodedSubtitles = [String]()

        for subtitle in subtitles {
            encodedSubtitles.append("\(subtitle.startTimestamp.stringFormat()):\(subtitle.text)")
        }

        return encodedSubtitles
    }
}

private extension Timestamp {
    func stringFormat() -> String {
        let minutes = self - Timestamp(value: self.numberOfFull(.hours), unit: .hours)
        let seconds = minutes - Timestamp(value: minutes.numberOfFull(.minutes), unit: .minutes)

        return
            "\(self.numberOfFull(.hours).toString(leadingZeros: 2)):" +
            "\(minutes.numberOfFull(.minutes).toString(leadingZeros: 2)):" +
            "\(seconds.numberOfFull(.seconds).toString(leadingZeros: 2))"
    }
}
