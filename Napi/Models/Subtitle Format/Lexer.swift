//
//  Lexer.swift
//  Napi
//
//  Created by Mateusz Karwat on 31/05/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

struct Lexer<TokenType> {
    let stream: String
    var tokenGenerators: [TokenGenerator<TokenType>]
    
    private(set) var tokens = [Token<TokenType>]()
    private(set) var unmatchedSubstreams = [String]()
    
    init(stream: String, tokenGenerators: [TokenGenerator<TokenType>]) {
        self.stream = stream
        self.tokenGenerators = tokenGenerators
    }
    
    mutating func lex() {
        var currentMatchIndex = 0
        var lastMatchedIndex = 0
        
        while currentMatchIndex < stream.characters.count {
            let substringToMatch = stream.substringFromIndex(currentMatchIndex)
            
            if let (generator, matchedPrefix) = findMatch(in: substringToMatch) {
                tokens.append(generator.tokenForStream(matchedPrefix))
                
                if lastMatchedIndex < currentMatchIndex {
                    unmatchedSubstreams.append(stream[lastMatchedIndex..<currentMatchIndex])
                }
                
                currentMatchIndex += matchedPrefix.characters.count
                lastMatchedIndex = currentMatchIndex
                continue
            }
            
            currentMatchIndex += 1
        }
        
        if lastMatchedIndex < currentMatchIndex {
            unmatchedSubstreams.append(stream[lastMatchedIndex..<currentMatchIndex])
        }
    }
    
    private func findMatch(in string: String) -> (TokenGenerator<TokenType>, String)? {
        let range = NSMakeRange(0, string.characters.count)
        
        for tokenGenerator in tokenGenerators {
            if let regex = try? NSRegularExpression(pattern: tokenGenerator.pattern, options: []),
                let match = regex.firstMatchInString(string, options: [.Anchored], range: range) {
                return (tokenGenerator, string.substringToIndex(match.range.length))
            }
        }
        
        return nil
    }
}
