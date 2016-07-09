//
//  Lexer.swift
//  Napi
//
//  Created by Mateusz Karwat on 31/05/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

class Lexer<TokenType: RawRepresentable> {
    private(set) var rules: [(RegularExpression, TokenType)]

    init(rules: [(RegularExpression, TokenType)]) {
        self.rules = rules
    }

    init?(rules: [(String, TokenType)]) {
        self.rules = []

        for (pattern, type) in rules {
            guard let regex = try? RegularExpression(pattern: pattern, options: []) else {
                return nil
            }
            self.rules.append((regex, type))
        }
    }

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
                unmatchedStream.characters.removeFirst()
            }
        }

        return tokens
    }

    private func match(of regex: RegularExpression, in stream: String) -> TextCheckingResult? {
        let streamRange = NSRange(location: 0, length: stream.characters.count)
        return regex.firstMatch(in: stream, options: [.anchored], range: streamRange)
    }
}
