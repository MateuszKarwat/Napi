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
        let subtitle = Subtitle(startTimestamp: 99_100.milliseconds,
                                stopTimestamp: 100_000.milliseconds,
                                text: "Test.")

        XCTAssertEqual(MPL2SubtitleFormat.encode([subtitle]), ["[991][1000]Test."])
    }

    func testDecodeCorrectInput() {
        let input = "[1][9999]Test."

        let decodedSubtitle = MPL2SubtitleFormat.decode(input)

        XCTAssertEqual(decodedSubtitle?.startTimestamp.baseValue, 100)
        XCTAssertEqual(decodedSubtitle?.stopTimestamp.baseValue, 999_900)
        XCTAssertEqual(decodedSubtitle?.text, "Test.")
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
