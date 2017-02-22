//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Requirements for types that are a subtitle format.
protocol SubtitleFormat {

    /// Specifies an extension of a file which stores specific format.
    static var fileExtension: String { get }

    /// Indicates whether subtitle format is based on time unit.
    static var isTimeBased: Bool { get }

    /// A regular expression that represents a syntax (format)
    /// of a specific subtitle format.
    static var regexPattern: String { get }

    /// Function which returns an instance of a subtitle.
    /// if given `String` matches `regexPattern`. Returns `nil` otherwise.
    static func decode(_ aString: String) -> [Subtitle]

    /// Returns a `String` which represents specific implementation
    /// of a subtitle format. This `String` must be in a format
    /// that is stored in a subtitle file. Must include all tags,
    /// formatters and timestamps required by file format.
    static func encode(_ subtitles: [Subtitle]) -> [String]

    /// Returns `String` representation of a given `Token`.
    /// If a given `Token` is not supported, it should return a `nil`.
    static func stringValue(for token: Token<SubtitleTokenType>) -> String?
}

extension SubtitleFormat {

    /// The fundamental matching method on NSRegularExpression is a block iterator.
    /// There are other additional convenience methods, for returning all matches at once, etc.
    /// Each match is specified by an instance of `SubtitleCheckingResult`.
    ///
    /// - Parameters:
    ///     - aString: A `String` which will be matched with `regexPattern`.
    ///       From this `String` all matches will be enumerated.
    ///     - block: For each match represented as `SubtitleCheckingResult`
    ///       this `block` will be triggered.
    static func enumerateMatches(in aString: String, using block: (SubtitleCheckingResult) -> ()) {
        guard let regex = try? NSRegularExpression(pattern: Self.regexPattern, options: []) else {
            return
        }

        let range = NSRange(location: 0, length: (aString as NSString).length)

        regex.enumerateMatches(in: aString, options: [], range: range) { (match, _, _) in
            if let match = match {
                var substrings = [String]()
                for rangeIdx in 1 ... match.numberOfRanges - 1 {
                    substrings.append(aString[match.rangeAt(rangeIdx)])
                }

                block(SubtitleCheckingResult(matchedString: aString[match.range], capturedSubstrings: substrings))
            }
        }
    }

    /// Function to return all matches generated by `enumerateMatches` function.
    ///
    /// - Parameter aString: A `String` which will be matched with `regexPattern`.
    ///   From this `String` all matched substrings will be extracted.
    ///
    /// - Returns: An `Array` of `SubtitleCheckingResult`.
    ///   Elements of the array are in order they are matched by `RegularExpression`.
    ///   If `regexPattern` is not a correct pattern for `RegularExpression`,
    ///   function will return an empty `Array`.
    static func matches(in aString: String) -> [SubtitleCheckingResult] {
        var matches = [SubtitleCheckingResult]()

        Self.enumerateMatches(in: aString) { match in
            matches.append(match)
        }

        return matches
    }

    /// Function to check if given `String` begins with a text
    /// which matches `regexPattern`.
    ///
    /// - Parameter aString: A text which gonna be verified if its
    ///   prefix matches `regexPattern`.
    ///
    /// - Returns: `true` if specified `String` begins with text
    ///   matched by `regexPattern`. Returns `false` otherwise.
    static func canDecode(_ aString: String) -> Bool {
        let range = NSRange(location: 0, length: aString.characters.count)

        if
            let regex = try? NSRegularExpression(pattern: Self.regexPattern, options: []),
            let _ = regex.firstMatch(in: aString, range: range) {
                return true
        }

        return false
    }
}

extension SubtitleFormat {

    // Default implementation of all subtitle token types.
    static func stringValue(for token: Token<SubtitleTokenType>) -> String? {
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
