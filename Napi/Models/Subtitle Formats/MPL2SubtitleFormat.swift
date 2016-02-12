//
//  MPL2Format.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

struct MPL2SubtitleFormat: SubtitleFormat {
    var startstamp: Timestamp?
    var stopstamp: Timestamp?
    var text: String
    
    /// The output looks like this:
    ///
    ///     [111][222]SomeText|Which is correct.
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