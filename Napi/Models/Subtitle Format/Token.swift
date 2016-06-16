//
//  Token.swift
//  Napi
//
//  Created by Mateusz Karwat on 31/05/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

struct Token<T>: CustomStringConvertible {
    let lexeme: String?
    let type: T
    
    init(type: T, lexeme: String? = nil) {
        self.lexeme = lexeme
        self.type = type
    }
    
    var description: String {
        if lexeme == nil {
            return "Token(\(type))"
        } else {
            return "Token(\(lexeme!), \(type))"
        }
    }
}

struct TokenGenerator<T> {
    let pattern: String
    let tokenForStream: (String) -> Token<T>
}
