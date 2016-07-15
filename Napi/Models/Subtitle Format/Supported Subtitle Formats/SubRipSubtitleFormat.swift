//
//  SRTFormat.swift
//  Napi
//
//  Created by Mateusz Karwat on 05/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

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
    var startTimestamp: Timestamp?
    var stopTimestamp: Timestamp?
    
    var text: String
    
    static let regexPattern =
        "^(\\d+)$\\n" +
        "^(\\d{1,2}):(\\d{1,2}):(\\d{1,2}),(\\d{1,3})" +
        " --> " +
        "^(\\d{1,2}):(\\d{1,2}):(\\d{1,2}),(\\d{1,3})" +
        "(^.+$\\n)+" +
        "\\n"

    static func decode(_ aString: String) -> SubRipSubtitleFormat? {
        // TODO: Implement
        return nil
    }

    func stringValue() -> String? {
        if let startTimestamp = startTimestamp, stopTimestamp = stopTimestamp {
            return
                "\(textNumber)\n" +
                "\(stringFormatForSubtitleTime(startTimestamp)) --> \(stringFormatForSubtitleTime(stopTimestamp))\n" +
                "\(text)\n" +
                "\n"
        }
        return nil
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
        let minutes = timestamp - TS(hours: timestamp.numberOfFullHours)
        let seconds = minutes - TS(minutes: minutes.numberOfFullMinutes)
        let milliseconds = seconds - TS(seconds: seconds.numberOfFullSeconds)

        return
            "\(timestamp.numberOfFullHours.toString(leadingZeros: 2)):" +
            "\(minutes.numberOfFullMinutes.toString(leadingZeros: 2)):" +
            "\(seconds.numberOfFullSeconds.toString(leadingZeros: 2))," +
            "\(milliseconds.milliseconds.toString(leadingZeros: 3))"
    }
}

extension Int {
    func toString(leadingZeros: Int) -> String {
        return String(format: "%0\(leadingZeros)d", self)
    }
}
