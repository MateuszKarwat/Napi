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

    func testMPL2TimeCodeFormattedValue() {
        XCTAssertEqual(MPL2TimeCode(totalNumberOfMilliseconds: 0).formattedString(), "0")
        XCTAssertEqual(MPL2TimeCode(totalNumberOfMilliseconds: 5).formattedString(), "0")
        // 1 minute, 39 seconds, 100 miliseconds
        XCTAssertEqual(MPL2TimeCode(totalNumberOfMilliseconds: 99_100).formattedString(), "991")
        // 1 hour, 1 minute, 39 seconds, 1 millisecond
        XCTAssertEqual(MPL2TimeCode(totalNumberOfMilliseconds: 3_699_555).formattedString(), "36995")
        XCTAssertEqual(MPL2TimeCode(totalNumberOfMilliseconds: 3_699_001).formattedString(), "36990")
        
        XCTAssertEqual(MPL2TimeCode(deciseconds: 0).formattedString(), "0")
        XCTAssertEqual(MPL2TimeCode(deciseconds: 991).formattedString(), "991")
    }
    
    func testMPL2SubtitleFormatFormattedValue() {
        let startTimeFromDeciseconds = MPL2TimeCode(deciseconds: 991)
        let endTimeFromDecisecons = MPL2TimeCode(deciseconds: 1000)
        
        let startTimeFromMilliseconds = MPL2TimeCode(totalNumberOfMilliseconds: 99_100)
        let endTimeFromMilliseconds = MPL2TimeCode(totalNumberOfMilliseconds: 100_000)
        
        let someText1 = ["It works!", "As expected."]
        let someText2 = ["This is one line of sample text"]
        
        let expectedFormattedValue1 = "[991][1000]It works!|As expected."
        let expectedFormattedValue2 = "[991][1000]This is one line of sample text"
        
        let mplFormat1 = MPL2SubtitleFormat(startTimeCode: startTimeFromDeciseconds, endTimeCode: endTimeFromDecisecons, linesOfText: someText1)
        let mplFormat2 = MPL2SubtitleFormat(startTimeCode: startTimeFromMilliseconds, endTimeCode: endTimeFromMilliseconds, linesOfText: someText1)
        XCTAssertEqual(mplFormat1.formattedString(), expectedFormattedValue1)
        XCTAssertEqual(mplFormat2.formattedString(), expectedFormattedValue1)
        
        let mplFormat3 = MPL2SubtitleFormat(startTimeCode: startTimeFromDeciseconds, endTimeCode: endTimeFromDecisecons, linesOfText: someText2)
        let mplFormat4 = MPL2SubtitleFormat(startTimeCode: startTimeFromMilliseconds, endTimeCode: endTimeFromMilliseconds, linesOfText: someText2)
        XCTAssertEqual(mplFormat3.formattedString(), expectedFormattedValue2)
        XCTAssertEqual(mplFormat4.formattedString(), expectedFormattedValue2)
    }
}
