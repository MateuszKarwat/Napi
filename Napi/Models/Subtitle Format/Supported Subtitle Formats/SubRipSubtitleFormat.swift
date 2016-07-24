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
    var textNumber: Int
    var startTimestamp: Timestamp
    var stopTimestamp: Timestamp
    
    var text: String
    
    static let regexPattern =
        "(\\d+)\\s" +
        "(\\d{1,2}):(\\d{1,2}):(\\d{1,2}),(\\d{1,3})" +
        " +--> +" +
        "(\\d{1,2}):(\\d{1,2}):(\\d{1,2}),(\\d{1,3})\\s" +
        "((?:.+\\s?)+\\S+)" // Take all lines of text, but don't include Whitespace at the very end.

    static func decode(_ aString: String) -> SubRipSubtitleFormat? {
        guard
            let substrings = SubRipSubtitleFormat.capturedSubstrings(from: aString),
            let lineNumber = Int(substrings[0]),
            substrings.count == 10 else {
                return nil
        }

        // Extract all numbers which represent hours, minutes, etc.
        var timestampNumbers = [Int]()
        for i in 1 ... 8 {
            guard let newNumber = Int(substrings[i]) else {
                return nil
            }

            timestampNumbers.append(newNumber)
        }

        let startStamp =
            timestampNumbers[0].hours +
            timestampNumbers[1].minutes +
            timestampNumbers[2].seconds +
            timestampNumbers[3].milliseconds
        let stopStamp =
            timestampNumbers[4].hours +
            timestampNumbers[5].minutes +
            timestampNumbers[6].seconds +
            timestampNumbers[7].milliseconds

        return SubRipSubtitleFormat(textNumber: lineNumber,
                                    startTimestamp: startStamp,
                                    stopTimestamp: stopStamp,
                                    text: substrings[9])
    }

    func stringValue() -> String {
        return
            "\(textNumber)\n" +
            "\(stringFormatForSubtitleTime(startTimestamp)) --> \(stringFormatForSubtitleTime(stopTimestamp))\n" +
            "\(text)\n"
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

extension SubRipSubtitleFormat {

    /// Returns `Timestamp` as a `String` that is compatible with SubRip format.
    private func stringFormatForSubtitleTime(_ timestamp: Timestamp)  -> String {
        let minutes = timestamp - Timestamp(value: timestamp.numberOfFull(.hours), unit: .hours)
        let seconds = minutes - Timestamp(value: minutes.numberOfFull(.minutes), unit: .minutes)
        let milliseconds = seconds - Timestamp(value: seconds.numberOfFull(.seconds), unit: .seconds)

        return
            "\(timestamp.numberOfFull(.hours).toString(leadingZeros: 2)):" +
            "\(minutes.numberOfFull(.minutes).toString(leadingZeros: 2)):" +
            "\(seconds.numberOfFull(.seconds).toString(leadingZeros: 2))," +
            "\(milliseconds.numberOfFull(.milliseconds).toString(leadingZeros: 3))"
    }
}

extension Int {
    func toString(leadingZeros: Int) -> String {
        return String(format: "%0\(leadingZeros)d", self)
    }
}
