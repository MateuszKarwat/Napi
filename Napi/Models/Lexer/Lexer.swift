//
//  Created by Mateusz Karwat on 31/05/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Lexer (Lexical Analysier) converts a string (stream) into a sequence of tokens.
final class Lexer<TokenType: RawRepresentable> {

    /// Rules of the lexer to identify tokens in the `stream`.
    private(set) var rules: [(NSRegularExpression, TokenType)]

    /// Creates a new instance with given sequence of rules.
    ///
    /// - Parameter rules: A sequence of tuples defining what kind of substring
    ///   indicates specific token. In other words description of the form that
    ///   the lexemes of a token may take. `TokenType` is a type of Token which should
    ///   be created if pattern matches any substring.
    init(rules: [(NSRegularExpression, TokenType)]) {
        self.rules = rules
    }

    /// Creates a new instance with given sequence of rules.
    ///
    /// - Parameter rules: A sequence of tuples defining what kind of substring indicates specific token.
    ///   In other words description of the form that the lexemes of a token may take.
    ///   `String` is a pattern for `RegularExpression` with `.caseInsensitive` option
    ///   and `TokenType` is a type of Token which should be created if pattern matches any substring.
    /// 
    /// - Note: Fails if any given string is not a correct pattern for `RegularExpression`.
    init?(rules: [(String, TokenType)]) {
        self.rules = []

        for (pattern, type) in rules {
            guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
                return nil
            }
            self.rules.append((regex, type))
        }
    }

    /// Go through the stream and try to find a sequence of tokens.
    ///
    /// If rule matches a prefix of a stream, token is created
    /// and matched substring is removed from futher process.
    /// Remaining suffix is a subject of futher analysis.
    ///
    /// If for none of the rules match is found, first character is dropped
    /// and matching process for a new stream (without first character) is repeated
    /// from the begining.
    ///
    /// Unmatched characters (for those which none rule does match) are skipped,
    /// and won't be presented in a result.
    ///
    /// - Important: Rules are matched in order they were given in init method.
    ///   This means, if first rule matches current prefix of a stream, all other rules
    ///   won't be checked if they match the same prefix.
    ///
    /// - Parameter stream: A string to tokenize.
    ///
    /// - Returns: A sequence of `Tokens` in order they were detected in given `stream`.
    func lex(stream: String) -> [Token<TokenType>] {
        var tokens = [Token<TokenType>]()
        var unmatchedStream = stream

        while !unmatchedStream.isEmpty {
            var nextToken: Token<TokenType>? = nil

            for (regex, tokenType) in rules {
                if let match = match(of: regex, in: unmatchedStream) {
                    nextToken = Token(type: tokenType, lexeme: unmatchedStream[match.range], pattern: regex)
                    unmatchedStream = unmatchedStream.substring(from: match.range.length)
                    break
                }
            }

            if let nextToken = nextToken {
                tokens.append(nextToken)
            } else {
                unmatchedStream.removeFirst()
            }
        }

        return tokens
    }

    /// Returns `TextCheckingResult` if `stream` starts with given `RegularExpression`.
    ///
    /// - Parameters:
    ///     - regex:  `RegularExpression` which should match a prefix of the `stream`.
    ///     - stream: A `String` which prefix should be checked if matches given `regex`.
    ///
    /// - Returns: `TextCheckingResult` if **prefix** of the `stream` matches `regex`.
    ///   `nil` if first match is not anchored or not found at all.
    private func match(of regex: NSRegularExpression, in stream: String) -> NSTextCheckingResult? {
        let streamRange = NSRange(location: 0, length: (stream as NSString).length)
        return regex.firstMatch(in: stream, options: [.anchored], range: streamRange)
    }
}
