//
//  Token.swift
//  Napi
//
//  Created by Mateusz Karwat on 31/05/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

struct Token<Type: RawRepresentable> {
    let type: Type
    let lexeme: String
    let pattern: RegularExpression
}

extension Token {
    var values: [String] {
        let match = pattern.firstMatch(in: lexeme, options: [], range: NSRange(location: 0, length: lexeme.characters.count))!

        var substrings = [String]()

        for i in 1 ..< match.numberOfRanges {
            let rangeOfSubstring = match.range(at: i)
            let substring = lexeme[rangeOfSubstring]

            substrings.append(substring)
        }

        return substrings
    }
}

// MARK: CustomStringConvertible

extension Token: CustomStringConvertible {
    var description: String {
        return "Token(\(type), \(values))"
    }
}
