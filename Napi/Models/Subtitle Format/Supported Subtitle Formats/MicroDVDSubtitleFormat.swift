//
//  MicroDVDSubtitleFormat.swift
//  Napi
//
//  Created by Mateusz Karwat on 07/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

/// Represents MicroDVD Subtitle Format.
/// MicroDVD Subtitle Format looks like this:
///
///     {111}{222}First line of a text.|Seconds line of a text.
struct MicroDVDSubtitleFormat: SubtitleFormat {
    var frameRate: Double
    var startTimestamp: Timestamp?
    var stopTimestamp: Timestamp?
    
    var text: String
    
    static let regexPattern = "^\\{(\\d++\\)}\\{(\\d++\\)}(.++)$"

    static func decode(_ aString: String) -> MicroDVDSubtitleFormat? {
        // TODO: Implement
        return nil
    }
    
    func stringValue() -> String? {
        if let
            startValue = startTimestamp?.numberOfFrames(withFrameRate: frameRate),
            stopValue = stopTimestamp?.numberOfFrames(withFrameRate: frameRate) {
            return "{\(startValue)}{\(stopValue)}\(text)"
        }
        return nil
    }
}
