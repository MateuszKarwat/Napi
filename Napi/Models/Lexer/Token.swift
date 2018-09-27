//
//  Created by Mateusz Karwat on 31/05/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// A token is a structure representing a lexeme that 
/// explicitly indicates its categorization for the purpose of parsing.
/// Tokens are identified based on the specific rules of the lexer.
struct Token<Type: RawRepresentable> {

    /// Indicates unique type to distinguish it from other tokens.
    let type: Type

    /// `String` of characters which forms a syntactic unit.
    /// In other words a substring matched during the lexical analysis.
    let lexeme: String

    /// Description of the form that the lexemes of a token may take.
    let pattern: NSRegularExpression
}

extension Token {

    /// Substrings of the `lexeme` which are extracted
    /// based on the `capture groups` of the `pattern`.
    var values: [String] {
        let match = pattern.firstMatch(in: lexeme, options: [], range: NSRange(location: 0, length: lexeme.count))!

        var substrings = [String]()

        for rangeIdx in 1 ..< match.numberOfRanges {
            let rangeOfSubstring = match.range(at: rangeIdx)
            let substring = lexeme[rangeOfSubstring]

            substrings.append(substring)
        }

        return substrings
    }
}

// MARK: - CustomStringConvertible

extension Token: CustomStringConvertible {
    var description: String {
        return "Token(\(type), lexeme: \(lexeme), values: \(values))"
    }
}
