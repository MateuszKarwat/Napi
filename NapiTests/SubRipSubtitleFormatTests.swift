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

//    func testSubRipTimeCodeFormattedValueFrommilliseconds() {
//        let timeCodeWithZeroValue = SubRipTimeCode(totalNumberOfMilliseconds: 0)
//        let timeCodeWithLowValue = SubRipTimeCode(totalNumberOfMilliseconds: 1)
//        let timeCodeWithStandardValue = SubRipTimeCode(totalNumberOfMilliseconds: 5_713_666)
//        let timeCodeWithMaxValue = SubRipTimeCode(totalNumberOfMilliseconds: 215_999_999)
//        
//        XCTAssertEqual(timeCodeWithZeroValue.stringFormat(), "00:00:00,000")
//        XCTAssertEqual(timeCodeWithLowValue.stringFormat(), "00:00:00,001")
//        XCTAssertEqual(timeCodeWithStandardValue.stringFormat(), "01:35:13,666")
//        XCTAssertEqual(timeCodeWithMaxValue.stringFormat(), "59:59:59,999")
//    }
//    
//    func testSubRipTimeCodeTotalNumberOfmilliseconds() {
//        let timeCodeWithZeroValue = SubRipTimeCode(hours: 0, minutes: 0, seconds: 0, milliseconds: 0)
//        let timeCodeWithLowValue = SubRipTimeCode(hours: 1, minutes: 1, seconds: 1, milliseconds: 1)
//        let timeCodeWithStandardValue = SubRipTimeCode(hours: 1, minutes: 35, seconds: 13, milliseconds: 666)
//        let timeCodeWithBigValue = SubRipTimeCode(hours: 59, minutes: 59, seconds: 59, milliseconds: 999)
//        
//        XCTAssertEqual(timeCodeWithZeroValue!.totalNumberOfMilliseconds, 0)
//        XCTAssertEqual(timeCodeWithLowValue!.totalNumberOfMilliseconds, 3_661_001)
//        XCTAssertEqual(timeCodeWithStandardValue!.totalNumberOfMilliseconds, 5_713_666)
//        XCTAssertEqual(timeCodeWithBigValue!.totalNumberOfMilliseconds, 215_999_999)
//    }
//    
//    func testSubRipTimeCodeFormattedValue() {
//        let timeCodeWithZeroValue = SubRipTimeCode(hours: 0, minutes: 0, seconds: 0, milliseconds: 0)
//        let timeCodeWithLowValue = SubRipTimeCode(hours: 0, minutes: 0, seconds: 0, milliseconds: 1)
//        let timeCodeWithStandardValue = SubRipTimeCode(hours: 1, minutes: 35, seconds: 13, milliseconds: 666)
//        let timeCodeWithMaxValue = SubRipTimeCode(hours: 59, minutes: 59, seconds: 59, milliseconds: 999)
//        
//        XCTAssertEqual(timeCodeWithZeroValue?.stringFormat(), "00:00:00,000")
//        XCTAssertEqual(timeCodeWithLowValue?.stringFormat(), "00:00:00,001")
//        XCTAssertEqual(timeCodeWithStandardValue?.stringFormat(), "01:35:13,666")
//        XCTAssertEqual(timeCodeWithMaxValue?.stringFormat(), "59:59:59,999")
//    }
    
    func testSubRipSubtitleFormatstringFormat() {
        let subRipTime1 = ST(hours: 1) + ST(minutes: 2) + ST(seconds: 3) + ST(milliseconds: 4)
        let subRipTime2 = ST(hours: 2) + ST(minutes: 3) + ST(seconds: 33) + ST(milliseconds: 40)
        
        let someText = ["You know nothing!", "John Snow..."]
        
        let correctSRT = SubRipSubtitleFormat(textNumber: 2, startTime: subRipTime1, stopTime: subRipTime2, linesOfText: someText)
        let expectedSRTFormat =
            "2\n" +
            "01:02:03,004 --> 02:03:33,040\n" +
            "You know nothing!\n" +
            "John Snow...\n" +
            "\n"
        XCTAssertEqual(correctSRT.stringFormat(), expectedSRTFormat)
    }
    
}
