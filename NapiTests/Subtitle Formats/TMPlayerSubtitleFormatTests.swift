//
//  TMPlayerSubtitleFormatTests.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import XCTest
@testable import Napi

class TMPlayerSubtitleFormatTests: XCTestCase {
    
    func testTMPLayerSubtitleFormatStringValue() {
        let subtitle = Subtitle(startTimestamp: 3_671_000.milliseconds,
                                stopTimestamp: 7_271_000.milliseconds,
                                text: "A long time ago...|In a galaxy far far away...")

        XCTAssertEqual(TMPlayerSubtitleFormat.encode([subtitle]),
                       ["01:01:11:A long time ago...|In a galaxy far far away..."])
    }

    func testDecodeCorrectInput() {
        let input = "01:01:11:A long time ago...|In a galaxy far far away..."

        let decodedSubtitle = TMPlayerSubtitleFormat.decode(input)

        XCTAssertEqual(decodedSubtitle[0].startTimestamp.baseValue, 3_671_000)
        XCTAssertEqual(decodedSubtitle[0].stopTimestamp.baseValue, 3_676_000)
        XCTAssertEqual(decodedSubtitle[0].text, "A long time ago...|In a galaxy far far away...")
    }

    func testDecodeIncorrectInput() {
        let incorrectInputs = ["  :01:11:Test.",
                               "01:  :11:Test.",
                               "01:01:  :Test.",
                               ":01:11:Test.",
                               "01::11:Test.",
                               "01:01::Test.",
                               "01:01:11:",
                               "Test."]

        for incorrectInput in incorrectInputs {
            XCTAssertTrue(TMPlayerSubtitleFormat.decode(incorrectInput).isEmpty,
                         "Assertion failed with input: \(incorrectInput)")
        }
    }
    
}
