//
//  TimeBasedSubtitleFormatProtocol.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

protocol TimeCodeFormat {
    var totalNumberOfMilliseconds: UInt { get }
    
    init(totalNumberOfMilliseconds: UInt)
    
    func formattedString() -> String
}

protocol TimeBasedSubtitleFormat {
    var startTimeCode: TimeCodeFormat { get }
    var endTimeCode: TimeCodeFormat { get }
    var linesOfText: [String] { get }
    var linesSeparator: String { get }
    
    func formattedString() -> String
}

extension TimeBasedSubtitleFormat {
    static var isTimeBased: Bool { return true }
}