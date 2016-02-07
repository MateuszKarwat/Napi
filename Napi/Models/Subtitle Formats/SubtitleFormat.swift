//
//  TimeBasedSubtitleFormatProtocol.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

protocol SubtitleFormat {
    static var isTimeBased: Bool { get }
    
    var linesOfText: [String] { get }
    var linesSeparator: String { get }
    
    func formattedString() -> String
}

// MARK: Time Based Protocol

protocol TimeBasedSubtitleFormat: SubtitleFormat {
    var startTimeCode: TimeCodeFormat { get }
    var stopTimeCode: TimeCodeFormat? { get }
}

extension TimeBasedSubtitleFormat {
    static var isTimeBased: Bool { return true }
    var stopTimeCode: TimeCodeFormat? { return nil }
}

protocol TimeCodeFormat {
    var totalNumberOfMilliseconds: UInt { get }
    
    init(totalNumberOfMilliseconds: UInt)
    
    func formattedString() -> String
}

// MARK: Frame Based Protocol

protocol FrameBasedSubtitleFormat: SubtitleFormat {
    var startFrame: UInt { get }
    var stopFrame: UInt? { get }
}

extension FrameBasedSubtitleFormat {
    static var isTimeBased: Bool { return false }
    var stopFrame: UInt? { return nil }
}