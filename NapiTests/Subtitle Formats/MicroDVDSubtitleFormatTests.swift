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
        let microDVDFormat = MicroDVDSubtitleFormat(startTimestamp: 0.frames(frameRate: 1.0),
                                                    stopTimestamp: 250.frames(frameRate: 1.0),
                                                    text: "Simple one line of a text")

        XCTAssertEqual(microDVDFormat.stringValue(), "{0}{250}Simple one line of a text")
    }

    func testDecodeCorrectInput() {
        let input = "{0}{100}Simple one line of a text"

        let microDVDFormat = MicroDVDSubtitleFormat.decode(input)

        XCTAssertEqual(microDVDFormat?.startTimestamp.numberOfFull(.milliseconds), 0)
        XCTAssertEqual(microDVDFormat?.stopTimestamp.numberOfFull(.milliseconds), 4_170)
        XCTAssertEqual(microDVDFormat?.text, "Simple one line of a text")
    }

    func testDecodeIncorrectInput() {
        let incorrectInputs = ["{}{1}Test.",
                               "{1}{}Test.",
                               "{1}  Test.",
                               "  {1}Test.",
                               "{1}Test.",
                               "{1}{1}",
                               "Test."]

        for incorrectInput in incorrectInputs {
            XCTAssertNil(MicroDVDSubtitleFormat.decode(incorrectInput))
            XCTAssertNil(MicroDVDSubtitleFormat.decode(incorrectInput, frameRate: 1.0))
        }
    }

    func testDecodeCorrectInputWithframeRate() {
        let input = "{90000}{91525}Simple one line of a text"

        let microDVDFormat = MicroDVDSubtitleFormat.decode(input, frameRate: 25.0)

        XCTAssertEqual(microDVDFormat?.startTimestamp.baseValue, 3_600_000)
        XCTAssertEqual(microDVDFormat?.stopTimestamp.baseValue, 3_661_000)
        XCTAssertEqual(microDVDFormat?.text, "Simple one line of a text")
    }
    
}
