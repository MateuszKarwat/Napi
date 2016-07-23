//
//  TimeBasedSubtitleFormatProtocol.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Requirements for types that are a subtitle format.
protocol SubtitleFormat {

    /// Represents a timestamp that tells when subtitle
    /// should appear on a screen.
    var startTimestamp: Timestamp { get set }

    /// Represents a timestamp that tells when subtitle
    /// should disappear from a screen.
    var stopTimestamp: Timestamp { get set }

    /// Represents a text (subtitle) which is displayed on a screen.
    var text: String { get set }

    /// A regular expression that represents a syntax (format)
    /// of a specific subtitle format.
    static var regexPattern: String { get }

    /// Function which returns an instance of subtitle format
    /// if given `String` matches `regexPattern`. Returns `nil` otherwise.
    static func decode(_ aString: String) -> Self?

    /// Returns a `String` which represents specific implementation
    /// of a subtitle format. This `String` must be in a format
    /// that is stored in a subtitle file. Must include all tags,
    /// formatters and timestamps required by file format.
    func stringValue() -> String

    /// Returns `String` representation of a given `Token`.
    /// If a given `Token` is not supported, it should return a `nil`.
    func stringValue(for token: Token<SubtitleTokenType>) -> String?
}

extension SubtitleFormat {

    /// Function to extract substrings which base on capture groups
    /// specified in a `regexPattern`.
    ///
    /// - Parameter aString: A `String` which will be matched with `regexPattern`.
    ///   From this `String` all capture groups will be extracted.
    ///
    /// - Returns: An `Array` of strings which are a substrings of given `String`.
    ///   Elements of the array are in order they are matched by capture groups.
    ///   If `regexPattern` is not a correct pattern for `RegularExpression`,
    ///   function will return a `nil`.
    static func capturedSubstrings(from aString: String) -> [String]? {
        var substrings = [String]()
        let range = NSRange(location: 0, length: aString.characters.count)

        guard
            let regex = try? RegularExpression(pattern: Self.regexPattern, options: []),
            let match = regex.firstMatch(in: aString, options: [], range: range) else {
                return nil
        }

        for i in 1 ... match.numberOfRanges - 1 {
            substrings.append(aString[match.range(at: i)])
        }

        return substrings
    }
}

extension SubtitleFormat {

    // Default implementation of all subtitle token types.
    func stringValue(for token: Token<SubtitleTokenType>) -> String? {
        switch token.type {
        case .boldStart:        return "{y:b}"
        case .boldEnd:          return "{/y:b}"
        case .italicStart:      return "{y:i}"
        case .italicEnd:        return "{/y:i}"
        case .underlineStart:   return "{y:u}"
        case .underlineEnd:     return "{/y:u}"
        case .fontColorStart:   return "{c:\(token.values.first ?? "$FFFFFF")}"
        case .fontColorEnd:     return "{/c}"
        case .whitespace:       return " "
        case .newLine:          return "|"
        case .word:             return "\(token.lexeme)"
        case .unknownCharacter: return "\(token.lexeme)"
        }
    }
}

/// Represents all supported subtitle formats by this application.
enum SupportedSubtitleFormat {
    case mpl2
    case microDVD
    case subRip
    case tmplayer

    /// Returns a sequence with all supported subtitle formats.
    var allSupportedSubtitleFormats: [SupportedSubtitleFormat] {
        return [mpl2, microDVD, subRip, tmplayer]
    }
}
