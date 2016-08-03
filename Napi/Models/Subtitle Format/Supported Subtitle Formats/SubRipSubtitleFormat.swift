//
//  SRTFormat.swift
//  Napi
//
//  Created by Mateusz Karwat on 05/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Represents SubRip Subtitle Format.
/// SubRip Subtitle Format looks like this:
///
///     2
///     01:01:01,111 --> 02:02:02,222
///     First line of a text.
///     Seconds line of a text.
///     \n
struct SubRipSubtitleFormat: SubtitleFormat {
    static let fileExtension = "srt"
    static let isTimeBased = true
    static let regexPattern =
        "(\\d+)\\s" +
        "(\\d{1,2}):(\\d{1,2}):(\\d{1,2}),(\\d{1,3})" +
        " +--> +" +
        "(\\d{1,2}):(\\d{1,2}):(\\d{1,2}),(\\d{1,3})\\s" +
        "((?:.+\\s?)+\\S+)" // Take all lines of text, but don't include Whitespace at the very end.

    static func decode(_ aString: String) -> [Subtitle] {
        var decodedSubtitles = [Subtitle]()

        self.enumerateMatches(in: aString) { match in
            // Extract all numbers which represent hours, minutes, etc.
            var timestampNumbers = [Int]()
            for i in 1 ... 8 {
                let newNumber = Int(match.capturedSubstrings[i])!
                timestampNumbers.append(newNumber)
            }

            let startTimestamp =
                    timestampNumbers[0].hours +
                    timestampNumbers[1].minutes +
                    timestampNumbers[2].seconds +
                    timestampNumbers[3].milliseconds
            let stopTimestamp =
                    timestampNumbers[4].hours +
                    timestampNumbers[5].minutes +
                    timestampNumbers[6].seconds +
                    timestampNumbers[7].milliseconds

            let newSubtitle = Subtitle(startTimestamp: startTimestamp,
                                       stopTimestamp: stopTimestamp,
                                       text: match.capturedSubstrings[9])

            decodedSubtitles.append(newSubtitle)
        }
        
        return decodedSubtitles
    }

    static func encode(_ subtitles: [Subtitle]) -> [String] {
        var encodedSubtitles = [String]()

        for (index, subtitle) in subtitles.enumerated() {
            encodedSubtitles.append(
                "\(index + 1)\n" +
                "\(subtitle.startTimestamp.stringFormat())" +
                " --> " +
                "\(subtitle.stopTimestamp.stringFormat())\n" +
                "\(subtitle.text)" +
                "\n"
            )
        }

        return encodedSubtitles
    }

    func stringValue(for token: Token<SubtitleTokenType>) -> String? {
        switch token.type {
        case .boldStart:        return "<b>"
        case .boldEnd:          return "</b>"
        case .italicStart:      return "<i>"
        case .italicEnd:        return "</i>"
        case .underlineStart:   return "<u>"
        case .underlineEnd:     return "</u>"
        case .fontColorStart:   return "<font color=\"\(token.values.first ?? "#FFFFFF")\">"
        case .fontColorEnd:     return "</font>"
        case .whitespace:       return " "
        case .newLine:          return "\n"
        case .word:             return "\(token.lexeme)"
        case .unknownCharacter: return "\(token.lexeme)"
        }
    }
}

private extension Timestamp {
    func stringFormat() -> String {
        let minutes = self - Timestamp(value: self.numberOfFull(.hours), unit: .hours)
        let seconds = minutes - Timestamp(value: minutes.numberOfFull(.minutes), unit: .minutes)
        let milliseconds = seconds - Timestamp(value: seconds.numberOfFull(.seconds), unit: .seconds)

        return
            "\(self.numberOfFull(.hours).toString(leadingZeros: 2)):" +
            "\(minutes.numberOfFull(.minutes).toString(leadingZeros: 2)):" +
            "\(seconds.numberOfFull(.seconds).toString(leadingZeros: 2))," +
            "\(milliseconds.numberOfFull(.milliseconds).toString(leadingZeros: 3))"
    }
}
