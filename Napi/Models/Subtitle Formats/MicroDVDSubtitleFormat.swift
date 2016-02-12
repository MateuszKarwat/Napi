//
//  MicroDVDSubtitleFormat.swift
//  Napi
//
//  Created by Mateusz Karwat on 07/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

struct MicroDVDSubtitleFormat: SubtitleFormat {
    var startstamp: Framestamp?
    var stopstamp: Framestamp?
    var text: String
    
    /// The output looks like this:
    ///
    ///     {111}{222}Some text.
    func stringValue() -> String? {
        if let startValue = startstamp?.frames, stopValue = stopstamp?.frames {
            return "{\(startValue)}{\(stopValue)}\(text)"
        }
        return nil
    }
    
    func stringValueForTextStyle(style: TextStyle) -> String? {
        return nil
    }
}