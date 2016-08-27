//
//  String+Substring.swift
//  Napi
//
//  Created by Mateusz Karwat on 31/05/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

extension String {

    /// Returns a new string containing the characters of the `String`
    /// from the one at a given `index` to the end.
    func substring(from index: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: index))
    }

    /// Returns a new string containing the characters of the `String` up to,
    /// but not including, the one at a given `index`.
    func substring(to index: Int) -> String {
        return self.substring(to: self.characters.index(self.startIndex, offsetBy: index))
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

    subscript (r: NSRange) -> String {
        return (self as NSString).substring(with: r)
    }
}
