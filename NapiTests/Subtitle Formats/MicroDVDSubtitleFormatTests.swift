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
        let microDVDFormat = MicroDVDSubtitleFormat(frameRate: 1.0,
                                                    startTimestamp: TS(milliseconds: 0),
                                                    stopTimestamp: TS(frames: 250, frameRate: 1.0),
                                                    text: "Simple one line of a text")

        XCTAssertEqual(microDVDFormat.stringValue(), "{0}{250}Simple one line of a text")
    }

    func testStringValueNil() {
        let timestamp = TS(milliseconds: 1000)

        XCTAssertNil(MicroDVDSubtitleFormat(frameRate: 1.0,
                                            startTimestamp: nil,
                                            stopTimestamp: timestamp,
                                            text: "Test").stringValue())

        XCTAssertNil(MicroDVDSubtitleFormat(frameRate: 1.0,
                                            startTimestamp: timestamp,
                                            stopTimestamp: nil,
                                            text: "Test").stringValue())
    }

    func testDecodeCorrectInput() {
        let input = "{0}{100}Simple one line of a text"

        let microDVDFormat = MicroDVDSubtitleFormat.decode(input)

        XCTAssertEqual(microDVDFormat?.startTimestamp?.milliseconds, 0)
        XCTAssertEqual(microDVDFormat?.stopTimestamp?.milliseconds, 4_171)
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

    func testDecodeCorrectInputWithFrameRate() {
        let input = "{90000}{91525}Simple one line of a text"

        let microDVDFormat = MicroDVDSubtitleFormat.decode(input, frameRate: 25.0)

        XCTAssertEqual(microDVDFormat?.startTimestamp?.milliseconds, 3_600_000)
        XCTAssertEqual(microDVDFormat?.stopTimestamp?.milliseconds, 3_661_000)
        XCTAssertEqual(microDVDFormat?.text, "Simple one line of a text")
    }
    
}
