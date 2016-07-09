//
//  MicroDVDSubtitleFormatTests.swift
//  Napi
//
//  Created by Mateusz Karwat on 07/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import XCTest
@testable import Napi

class MicroDVDSubtitleFormatTests: XCTestCase {

    func testStringValue() {
        let oneLineOfText = "Simple one line of text"
        XCTAssertEqual(
            MicroDVDSubtitleFormat(
                frameRate: 1.0,
                startTimestamp: Timestamp(milliseconds: 0),
                stopTimestamp: Timestamp(frames: 250, frameRate: 1.0),
                text: oneLineOfText).stringValue(),
            "{0}{250}Simple one line of text"
        )
    }

}
