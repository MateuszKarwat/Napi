//
//  MPL2SubtitleFormatTests.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import XCTest
@testable import Napi

class MPL2SubtitleFormatTests: XCTestCase {
    
    func testStringValue() {
        let mplFormat = MPL2SubtitleFormat(startTimestamp: 99_100.milliseconds,
                                           stopTimestamp: 100_000.milliseconds,
                                           text: "Test.")

        XCTAssertEqual(mplFormat.stringValue(), "[991][1000]Test.")
    }

    func testDecodeCorrectInput() {
        let input = "[1][9999]Test."

        let mplFormat = MPL2SubtitleFormat.decode(input)

        XCTAssertEqual(mplFormat?.startTimestamp.baseValue, 100)
        XCTAssertEqual(mplFormat?.stopTimestamp.baseValue, 999_900)
        XCTAssertEqual(mplFormat?.text, "Test.")
    }

    func testDecodeIncorrectInput() {
        let incorrectInputs = ["[][1]Test.",
                               "[1][]Test.",
                               "[1]  Test.",
                               "  [1]Test.",
                               "[1]Test.",
                               "[1][1]",
                               "Test."]

        for incorrectInput in incorrectInputs {
            XCTAssertNil(MPL2SubtitleFormat.decode(incorrectInput))
        }
    }

}
