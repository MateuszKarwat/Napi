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
    
    func testTMPLayerSubtitleFormatFormattedValue() {
        let tmplayerFormat = TMPlayerSubtitleFormat(startTimestamp: TS(milliseconds: 3_671_000),
                                                    stopTimestamp: TS(milliseconds: 7_271_000),
                                                    text: "A long time ago...|In a galaxy far far away...")

        XCTAssertEqual(tmplayerFormat.stringValue(), "01:01:11:A long time ago...|In a galaxy far far away...")
    }

    func testDecodeCorrectInput() {
        let input = "01:01:11:A long time ago...|In a galaxy far far away..."

        let tmplayerFormat = TMPlayerSubtitleFormat.decode(input)

        XCTAssertEqual(tmplayerFormat?.startTimestamp.milliseconds, 3_671_000)
        XCTAssertEqual(tmplayerFormat?.stopTimestamp.milliseconds, 3_676_000)
        XCTAssertEqual(tmplayerFormat?.text, "A long time ago...|In a galaxy far far away...")
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
            XCTAssertNil(TMPlayerSubtitleFormat.decode(incorrectInput),
                         "Assertion failed with input: \(incorrectInput)")
        }
    }
    
}
