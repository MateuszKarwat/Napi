//
//  String+Substring.swift
//  Napi
//
//  Created by Mateusz Karwat on 31/05/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

public extension String {
    public func substring(from index: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: index))
    }
    
    public func substring(to index: Int) -> String {
        return self.substring(to: self.characters.index(self.startIndex, offsetBy: index))
    }
}

public extension String {
    public subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    public subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    public subscript (r: Range<Int>) -> String {
        let start = characters.index(startIndex, offsetBy: r.lowerBound)
        let end = characters.index(start, offsetBy: r.upperBound - r.lowerBound)
        return self[Range(start ..< end)]
    }
}
