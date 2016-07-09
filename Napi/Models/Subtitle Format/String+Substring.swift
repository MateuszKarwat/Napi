//
//  String+Substring.swift
//  Napi
//
//  Created by Mateusz Karwat on 31/05/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

extension String {
    func substring(from index: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: index))
    }
    
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
    
    subscript (r: Range<Int>) -> String {
        let start = characters.index(startIndex, offsetBy: r.lowerBound)
        let end = characters.index(start, offsetBy: r.upperBound - r.lowerBound)
        return self[Range(start ..< end)]
    }

    subscript (r: NSRange) -> String {
        return self[Range(r.location ..< r.location + r.length)]
    }
}
