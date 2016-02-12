//
//  SupportedSubtitleFormats.swift
//  Napi
//
//  Created by Mateusz Karwat on 12/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

enum SupportedSubtitleFormat {
    case MPL2
    case MicroDVD
    case SubRip
    case TMPlayer
    
    var allSupportedSubtitleFormats: [SupportedSubtitleFormat] {
        return [MPL2, MicroDVD, SubRip, TMPlayer]
    }
}