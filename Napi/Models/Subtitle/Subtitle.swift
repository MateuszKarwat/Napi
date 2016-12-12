//
//  Created by Mateusz Karwat on 26/07/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

/// Represents a single subtitle (entry) which appears
/// on a screen at specified time.
struct Subtitle {

    /// Represents a timestamp that tells when subtitle
    /// should appear on a screen.
    var startTimestamp: Timestamp

    /// Represents a timestamp that tells when subtitle
    /// should disappear from a screen.
    var stopTimestamp: Timestamp

    /// Represents a text which is displayed on a screen.
    var text: String
}

// MARK: - Text Tokenization

extension Subtitle {

    /// Returns an `Array` of `Tokens` created by `Lexer`
    /// using `defaultSubtitleRules`.
    ///
    /// - Note: See also `SubtitleTokenType` enum implementation.
    var tokenizedText: [Token<SubtitleTokenType>] {
        if let lexer = Lexer(rules: Lexer<SubtitleTokenType>.defaultSubtitleRules) {
            return lexer.lex(stream: text)
        }

        return []
    }
}
