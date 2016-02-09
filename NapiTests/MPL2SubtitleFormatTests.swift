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

//    func testMPL2TimeCodeFormattedValue() {
//        XCTAssertEqual(MPL2TimeCode(totalNumberOfMilliseconds: 0).stringFormat(), "0")
//        XCTAssertEqual(MPL2TimeCode(totalNumberOfMilliseconds: 5).stringFormat(), "0")
//        // 1 minute, 39 seconds, 100 miliseconds
//        XCTAssertEqual(MPL2TimeCode(totalNumberOfMilliseconds: 99_100).stringFormat(), "991")
//        // 1 hour, 1 minute, 39 seconds, 1 millisecond
//        XCTAssertEqual(MPL2TimeCode(totalNumberOfMilliseconds: 3_699_555).stringFormat(), "36995")
//        XCTAssertEqual(MPL2TimeCode(totalNumberOfMilliseconds: 3_699_001).stringFormat(), "36990")
//        
//        XCTAssertEqual(MPL2TimeCode(deciseconds: 0).stringFormat(), "0")
//        XCTAssertEqual(MPL2TimeCode(deciseconds: 991).stringFormat(), "991")
//    }
    
    func testMPL2SubtitleFormatStingFormat() {
        let startTime = ST(milliseconds: 99_100)
        let stopTime = ST(milliseconds: 100_000)
        
        let someText1 = ["It works!", "As expected."]
        let someText2 = ["This is one line of sample text"]
        
        let expectedFormattedValue1 = "[991][1000]It works!|As expected."
        let expectedFormattedValue2 = "[991][1000]This is one line of sample text"
        
        let mplFormat1 = MPL2SubtitleFormat(startTime: startTime, stopTime: stopTime, linesOfText: someText1)
        XCTAssertEqual(mplFormat1.stringFormat(), expectedFormattedValue1)
        
        let mplFormat2 = MPL2SubtitleFormat(startTime: startTime, stopTime: stopTime, linesOfText: someText2)
        XCTAssertEqual(mplFormat2.stringFormat(), expectedFormattedValue2)
    }
}
