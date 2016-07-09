//
//  MicroDVDSubtitleFormat.swift
//  Napi
//
//  Created by Mateusz Karwat on 07/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

/// MicroDVD Subtitle Format looks like this:
///
///     {111}{222}First line of text.|Seconds line of text.
struct MicroDVDSubtitleFormat: SubtitleFormat {
    var frameRate: Double
    var startTimestamp: Timestamp?
    var stopTimestamp: Timestamp?
    
    var text: String
    static let regexPattern = "^\\{(\\d++\\)}\\{(\\d++\\)}(.++)$"
    
    func stringValue() -> String? {
        if let
            startValue = startTimestamp?.numberOfFrames(withFrameRate: frameRate),
            stopValue = stopTimestamp?.numberOfFrames(withFrameRate: frameRate) {
            return "{\(startValue)}{\(stopValue)}\(text)"
        }
        return nil
    }

    func stringValue<TokenType>(for: Token<TokenType>) -> String? {
        // TODO: Implement
        return nil
    }
}
