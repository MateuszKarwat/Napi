//
//  MPL2Format.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

/// MPL2 Subtitle Format looks like this:
///
///     [111][222]First line of text.|Seconds line of text.
struct MPL2SubtitleFormat: SubtitleFormat {
    var startstamp: Timestamp?
    var stopstamp: Timestamp?
    var text: String
    static let regexPattern = "^\\[(\\d++\\)]\\[(\\d++\\)](.++)$"
    
    func stringValue() -> String? {
        if let startValue = startstamp?.milliseconds, stopValue = stopstamp?.milliseconds {
            return "[\(startValue / 100)][\(stopValue / 100)]\(text)"
        }
        return nil
    }
    
    func stringValueForTextStyle(style: TextStyle) -> String? {
        switch style {
        default:
            return nil
        }
    }
}