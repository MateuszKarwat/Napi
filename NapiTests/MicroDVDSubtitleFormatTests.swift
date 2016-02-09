//
//  MicroDVDSubtitleFormatTests.swift
//  Napi
//
//  Created by Mateusz Karwat on 07/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import XCTest

class MicroDVDSubtitleFormatTests: XCTestCase {

    func testMicroDVDSubtitleFormatFormattedValue() {
        let oneLineOfText = ["Simple one line of text"]
        XCTAssertEqual(
            MicroDVDSubtitleFormat(startFrame: 0, stopFrame: 250, linesOfText: oneLineOfText).stringFormat(),
            "{0}{250}Simple one line of text"
        )
        
        let multipleLinesOfText = ["This is a first line of text", "This is second", "And this is next one"]
        XCTAssertEqual(
            MicroDVDSubtitleFormat(startFrame: 250, stopFrame: 1500, linesOfText: multipleLinesOfText).stringFormat(),
            "{250}{1500}This is a first line of text|This is second|And this is next one"
        )
    }

}
