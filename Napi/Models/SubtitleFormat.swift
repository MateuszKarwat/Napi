//
//  TimeBasedSubtitleFormatProtocol.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

// MARK: Protocols

protocol SubtitleFormat {
    typealias Stamp: SubtitleStamp
    
    var startstamp: Stamp? { get set }
    var stopstamp: Stamp? { get set }
    var text: String { get set }
    
    func stringValue() -> String?
    func stringValueForTextStyle(style: TextStyle) -> String?
}

protocol SubtitleStamp {
    var type: SubtitleStampType { get }
    var absoluteValue: UInt { get }
}

// MARK: Enumerators

enum TextStyle {
    case Bold
    case Underline
    case NewLine
}

enum SubtitleStampType {
    case TimeBased
    case FrameBased(FPS: Double)
}