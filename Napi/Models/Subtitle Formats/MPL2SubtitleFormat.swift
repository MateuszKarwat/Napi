//
//  MPL2Format.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

/// Struct to store all informations required in MPL2 subtitle format.
struct MPL2SubtitleFormat: TimeBasedSubtitleFormat {
    let startTimeCode: TimeCodeFormat
    let stopTimeCode: TimeCodeFormat?
    let linesOfText: [String]
    let linesSeparator: String = "|"
    
    init(startTimeCode: MPL2TimeCode, stopTimeCode: MPL2TimeCode, linesOfText: [String]) {
        self.startTimeCode = startTimeCode
        self.stopTimeCode = stopTimeCode
        self.linesOfText = linesOfText
    }
    
    /// Function returns formatted string in correct MPL2 subtitle format.
    /// The output looks like this:
    ///
    ///     [111][222]SomeText|Which is correct.
    func formattedString() -> String {
        return "[\(startTimeCode.formattedString())][\(stopTimeCode!.formattedString())]" +
            "\(linesOfText.joinWithSeparator(linesSeparator))"
    }
}

/// A struct to store time unit used in MPL2 subtitle format.
struct MPL2TimeCode: TimeCodeFormat {
    let totalNumberOfMilliseconds: UInt
    var deciseconds: UInt {
        return totalNumberOfMilliseconds / 100
    }
    
    init(totalNumberOfMilliseconds: UInt) {
        self.totalNumberOfMilliseconds = totalNumberOfMilliseconds
    }
    
    init(deciseconds: UInt) {
        totalNumberOfMilliseconds = deciseconds * 100
    }
    
    func formattedString() -> String {
        return "\(deciseconds)"
    }
}