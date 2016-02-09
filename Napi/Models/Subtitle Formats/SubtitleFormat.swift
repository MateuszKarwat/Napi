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
    
    func stringFormat() -> String
}

// MARK: Time Based Protocol

protocol TimeBasedSubtitleFormat: SubtitleFormat {
    var startTime: SubtitleTime { get }
    var stopTime: SubtitleTime? { get }
}

extension TimeBasedSubtitleFormat {
    static var isTimeBased: Bool { return true }
    var stopTime: SubtitleTime? { return nil }
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