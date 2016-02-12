//
//  MicroDVDSubtitleFormatTests.swift
//  Napi
//
//  Created by Mateusz Karwat on 07/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import XCTest

class MicroDVDSubtitleFormatTests: XCTestCase {

    func testStringValue() {
        let oneLineOfText = "Simple one line of text"
        XCTAssertEqual(
            MicroDVDSubtitleFormat(startstamp: Framestamp(), stopstamp: Framestamp(frames: 250, frameRate: 0.0), text: oneLineOfText).stringValue(),
            "{0}{250}Simple one line of text"
        )
    }

}
