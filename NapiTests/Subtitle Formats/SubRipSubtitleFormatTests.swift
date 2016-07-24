//
//  SRTFormatTests.swift
//  Napi
//
//  Created by Mateusz Karwat on 05/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import XCTest
@testable import Napi

class SubRipSubtitleFormatTests: XCTestCase {
    
    func testStringFormat() {
        let startTimestamp = 1.hours + 2.minutes + 3.seconds + 4.milliseconds
        let stopTimestamp = 2.hours + 3.minutes + 33.seconds + 40.milliseconds
        
        let subRipFormat = SubRipSubtitleFormat(textNumber: 2,
                                                startTimestamp: startTimestamp,
                                                stopTimestamp: stopTimestamp,
                                                text: "You know nothing!\nJohn Snow...")

        let expectedStringValue =
            "2\n" +
            "01:02:03,004 --> 02:03:33,040\n" +
            "You know nothing!\n" +
            "John Snow...\n"

        XCTAssertEqual(subRipFormat.stringValue(), expectedStringValue)
    }
    
    func testDecodeCorrectInput() {
        let input =
            "2\n" +
            "01:02:03,004 --> 02:03:33,040\n" +
            "You know nothing!\n" +
            "John Snow...\n" +
            "\n"


        let srtFormat = SubRipSubtitleFormat.decode(input)

        let startTimestamp = 1.hours + 2.minutes + 3.seconds + 4.milliseconds
        let stopTimestamp = 2.hours + 3.minutes + 33.seconds + 40.milliseconds

        XCTAssertEqual(srtFormat?.textNumber, 2)
        XCTAssertEqual(srtFormat?.startTimestamp.baseValue, startTimestamp.baseValue)
        XCTAssertEqual(srtFormat?.stopTimestamp.baseValue, stopTimestamp.baseValue)
        XCTAssertEqual(srtFormat?.text, "You know nothing!\nJohn Snow...")
    }

    func testDecodeIncorrectInput() {
        func assertBrokenInput(lineNumber: String = "2\n",
                               startTimestamp: String = "01:02:03,004",
                               arrow: String = " --> ",
                               stopTimestamp: String = "02:03:33,040\n",
                               text: String = "Test.") {
            let input = lineNumber + startTimestamp + arrow + stopTimestamp + text
            XCTAssertNil(SubRipSubtitleFormat.decode(input), "Assertion failed with input: \(input)")
        }

        // Incorrect lineNumber
        assertBrokenInput(lineNumber: "")
        assertBrokenInput(lineNumber: "\n")
        assertBrokenInput(lineNumber: "2")

        // Incorrect startTimestamp
        assertBrokenInput(startTimestamp: ":02:03,004")
        assertBrokenInput(startTimestamp: "01::03,004")
        assertBrokenInput(startTimestamp: "01:02:,004")
        assertBrokenInput(startTimestamp: "01:02:03,")

        // Incorrect stopTimestamp
        assertBrokenInput(stopTimestamp: "  :03:33,040\n")
        assertBrokenInput(stopTimestamp: "02:  :33,040\n")
        assertBrokenInput(stopTimestamp: "02:03:  ,040\n")
        assertBrokenInput(stopTimestamp: "02:03:33,   \n")
        assertBrokenInput(stopTimestamp: "02:03:33,040")

        // Incorrect arrow
        assertBrokenInput(arrow: " -> ")
        assertBrokenInput(arrow: " -- ")

        // Incorrect text
        assertBrokenInput(text: "")
        assertBrokenInput(text: " ")
        assertBrokenInput(text: "\n")
    }
    
}
