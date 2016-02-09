//
//  MicroDVDSubtitleFormat.swift
//  Napi
//
//  Created by Mateusz Karwat on 07/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

struct MicroDVDSubtitleFormat: FrameBasedSubtitleFormat {
    let startFrame: UInt
    let stopFrame: UInt
    
    var linesOfText: [String]
    var linesSeparator: String = "|"
    
    init(startFrame: UInt, stopFrame: UInt, linesOfText: [String]) {
        self.startFrame = startFrame
        self.stopFrame = stopFrame
        self.linesOfText = linesOfText
    }
    
    func stringFormat() -> String {
        return "{\(startFrame)}{\(stopFrame)}\(linesOfText.joinWithSeparator(linesSeparator))"
    }
}