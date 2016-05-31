//
//  TimeBasedSubtitleFormatProtocol.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

protocol SubtitleFormat {
    var startTimestamp: Timestamp? { get set }
    var stopTimestamp: Timestamp? { get set }
    
    var text: String { get set }
    static var regexPattern: String { get }
    
    func stringValue() -> String?
}

extension SubtitleFormat {
    // TODO: Implement computed property for tokenized text
}

enum SupportedSubtitleFormat {
    case MPL2
    case MicroDVD
    case SubRip
    case TMPlayer
    
    var allSupportedSubtitleFormats: [SupportedSubtitleFormat] {
        return [MPL2, MicroDVD, SubRip, TMPlayer]
    }
}