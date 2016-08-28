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
        return (self as NSString).substring(from: index)
    }

    /// Returns a new string containing the characters of the `String` up to,
    /// but not including, the one at a given `index`.
    func substring(to index: Int) -> String {
        return (self as NSString).substring(to: index)
    }
}

extension String {
    subscript (r: NSRange) -> String {
        return (self as NSString).substring(with: r)
    }
}
