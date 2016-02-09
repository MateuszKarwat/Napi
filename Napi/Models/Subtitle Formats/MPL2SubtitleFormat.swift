//
//  MPL2Format.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

/// Struct to store all informations required in MPL2 subtitle format.
struct MPL2SubtitleFormat: TimeBasedSubtitleFormat {
    let startTime: SubtitleTime
    let stopTime: SubtitleTime
    let linesOfText: [String]
    let linesSeparator: String = "|"
    
    init(startTime: SubtitleTime, stopTime: SubtitleTime, linesOfText: [String]) {
        self.startTime = startTime
        self.stopTime = stopTime
        self.linesOfText = linesOfText
    }
    
    /// Function returns formatted string in correct MPL2 subtitle format.
    /// The output looks like this:
    ///
    ///     [111][222]SomeText|Which is correct.
    func stringFormat() -> String {
        return
            "[\(startTime.milliseconds / 100)][\(stopTime.milliseconds / 100)]" +  // [111][222]
            "\(linesOfText.joinWithSeparator(linesSeparator))"                      // SomeText|Which is correct.
    }
}