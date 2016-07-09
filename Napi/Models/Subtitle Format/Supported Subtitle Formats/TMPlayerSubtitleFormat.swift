//
//  TMPlayerSubtitleFormat.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

/// TMPPlayer Subtitle Format looks like this:
///
///     01:12:33:First line of text.|Seconds line of text.
struct TMPlayerSubtitleFormat: SubtitleFormat {
    var startTimestamp: Timestamp?
    var stopTimestamp: Timestamp?
    
    var text: String
    static let regexPattern = "^(\\d{1,2}):(\\d{1,2}):(\\d{1,2}):(.++)$"
    
    func stringValue() -> String? {
        if let startTimestamp = startTimestamp {
            return "\(stringFormatForSubtitleTime(startTimestamp)):\(text)"
        }
        return nil
    }
    
    private func stringFormatForSubtitleTime(_ timestamp: Timestamp)  -> String {
        let minutes = timestamp - TS(hours: timestamp.numberOfFullHours)
        let seconds = minutes - TS(minutes: minutes.numberOfFullMinutes)
        
        return
            "\(timestamp.numberOfFullHours.toString(leadingZeros: 2)):" +
            "\(minutes.numberOfFullMinutes.toString(leadingZeros: 2)):" +
            "\(seconds.numberOfFullSeconds.toString(leadingZeros: 2))"
    }

    func stringValue<TokenType>(for: Token<TokenType>) -> String? {
        // TODO: Implement
        return nil
    }
}

extension Int {
    func toString(leadingZeros: Int) -> String {
        return String(format: "%0\(leadingZeros)d", self)
    }
}
