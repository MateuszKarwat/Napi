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
        let subtitle = Subtitle(startTimestamp: 0.frames(frameRate: 1.0),
                                stopTimestamp: 250.frames(frameRate: 1.0),
                                text: "Simple one line of a text")

        XCTAssertEqual(MicroDVDSubtitleFormat.encode([subtitle]), ["{0}{250}Simple one line of a text"])
    }

    func testDecodeCorrectInput() {
        let input = "{0}{100}First Subtitle" + "\n" + "{100}{200}Second Subtitle"

        let decodedSubtitle = MicroDVDSubtitleFormat.decode(input)

        XCTAssertEqual(decodedSubtitle[0].startTimestamp.numberOfFull(.milliseconds), 0)
        XCTAssertEqual(decodedSubtitle[0].stopTimestamp.numberOfFull(.milliseconds), 100_000)
        XCTAssertEqual(decodedSubtitle[0].text, "First Subtitle")

        XCTAssertEqual(decodedSubtitle[1].startTimestamp.numberOfFull(.milliseconds), 100_000)
        XCTAssertEqual(decodedSubtitle[1].stopTimestamp.numberOfFull(.milliseconds), 200_000)
        XCTAssertEqual(decodedSubtitle[1].text, "Second Subtitle")
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
            XCTAssertTrue(MicroDVDSubtitleFormat.decode(incorrectInput).isEmpty)
            XCTAssertTrue(MicroDVDSubtitleFormat.decode(incorrectInput, frameRate: 1.0).isEmpty)
        }
    }

    func testDecodeCorrectInputWithframeRate() {
        let input = "{90000}{91525}Simple one line of a text"

        let microDVDFormat = MicroDVDSubtitleFormat.decode(input, frameRate: 25.0)

        XCTAssertEqual(microDVDFormat[0].startTimestamp.baseValue, 3_600_000)
        XCTAssertEqual(microDVDFormat[0].stopTimestamp.baseValue, 3_661_000)
        XCTAssertEqual(microDVDFormat[0].text, "Simple one line of a text")
    }
    
}
