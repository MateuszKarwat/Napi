//
//  String+Substring.swift
//  Napi
//
//  Created by Mateusz Karwat on 31/05/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

public extension String {
    public func substringFromIndex(n: Int) -> String {
        return self.substringFromIndex(self.startIndex.advancedBy(n))
    }
    
    public func substringToIndex(n: Int) -> String {
        return self.substringToIndex(self.startIndex.advancedBy(n))
    }
}

public extension String {
    public subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    public subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    public subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }
}