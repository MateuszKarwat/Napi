//
//  TMPlayerSubtitleFormatTests.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import XCTest

class TMPlayerSubtitleFormatTests: XCTestCase {

    func testTMPlayerTimeCodeFormattedValue() {
        XCTAssertEqual(TMPlayerTimeCode(totalNumberOfMilliseconds: 0).formattedString(), "00:00:00")
        XCTAssertEqual(TMPlayerTimeCode(totalNumberOfMilliseconds: 5000).formattedString(), "00:00:05")
        XCTAssertEqual(TMPlayerTimeCode(totalNumberOfMilliseconds: 3_671_000).formattedString(), "01:01:11")
        XCTAssertEqual(TMPlayerTimeCode(totalNumberOfMilliseconds: 215_999_000).formattedString(), "59:59:59")
        
        XCTAssertEqual(TMPlayerTimeCode(hours: 0, minutes: 0, seconds: 0)?.formattedString(), "00:00:00")
        XCTAssertEqual(TMPlayerTimeCode(hours: 0, minutes: 0, seconds: 5)?.formattedString(), "00:00:05")
        XCTAssertEqual(TMPlayerTimeCode(hours: 1, minutes: 1, seconds: 1)?.formattedString(), "01:01:01")
        XCTAssertEqual(TMPlayerTimeCode(hours: 59, minutes: 59, seconds: 59)?.formattedString(), "59:59:59")
        
        XCTAssertNil(TMPlayerTimeCode(hours: 1, minutes: 60, seconds: 1))
        XCTAssertNil(TMPlayerTimeCode(hours: 1, minutes: 1, seconds: 60))
    }
    
    func testTMPlayerTimeCodeTotalNumberOfSeconds() {
        XCTAssertEqual(TMPlayerTimeCode(hours: 0, minutes: 0, seconds: 0)?.totalNumberOfMilliseconds, 0)
        XCTAssertEqual(TMPlayerTimeCode(hours: 0, minutes: 0, seconds: 5)?.totalNumberOfMilliseconds, 5000)
        XCTAssertEqual(TMPlayerTimeCode(hours: 1, minutes: 1, seconds: 1)?.totalNumberOfMilliseconds, 3_661_000)
        XCTAssertEqual(TMPlayerTimeCode(hours: 59, minutes: 59, seconds: 59)?.totalNumberOfMilliseconds, 215_999_000)
    }
    
    func testTMPLayerSubtitleFormatFormattedValue() {
        let timeCode1 = TMPlayerTimeCode(totalNumberOfMilliseconds: 3_671_000)
        let timeCode2 = TMPlayerTimeCode(totalNumberOfMilliseconds: 7_271_000)
        
        let sampleText1 = ["A long time ago...", "In a galaxy far far away..."]
        let sampleText2 = ["Text which is only one line long"]
        
        let expectedStringFormat1 = "01:01:11:A long time ago...|In a galaxy far far away..."
        let expectedStringFormat2 = "02:01:11:Text which is only one line long"
        
        XCTAssertEqual(TMPlayerSubtitleFormat(startTimeCode: timeCode1, linesOfText: sampleText1).formattedString(), expectedStringFormat1)
        XCTAssertEqual(TMPlayerSubtitleFormat(startTimeCode: timeCode2, linesOfText: sampleText2).formattedString(), expectedStringFormat2)
    }

}
