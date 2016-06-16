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
    case mpl2
    case microDVD
    case subRip
    case tmPlayer
    
    var allSupportedSubtitleFormats: [SupportedSubtitleFormat] {
        return [mpl2, microDVD, subRip, tmPlayer]
    }
}
