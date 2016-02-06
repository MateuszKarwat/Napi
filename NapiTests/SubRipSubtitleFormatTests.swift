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

    func testSubRipTimeCodeFormattedValueFrommilliseconds() {
        let timeCodeWithZeroValue = SubRipTimeCode(totalNumberOfMilliseconds: 0)
        let timeCodeWithLowValue = SubRipTimeCode(totalNumberOfMilliseconds: 1)
        let timeCodeWithStandardValue = SubRipTimeCode(totalNumberOfMilliseconds: 5_713_666)
        let timeCodeWithMaxValue = SubRipTimeCode(totalNumberOfMilliseconds: 215_999_999)
        
        XCTAssertEqual(timeCodeWithZeroValue.formattedString(), "00:00:00,000")
        XCTAssertEqual(timeCodeWithLowValue.formattedString(), "00:00:00,001")
        XCTAssertEqual(timeCodeWithStandardValue.formattedString(), "01:35:13,666")
        XCTAssertEqual(timeCodeWithMaxValue.formattedString(), "59:59:59,999")
    }
    
    func testSubRipTimeCodeTotalNumberOfmilliseconds() {
        let timeCodeWithZeroValue = SubRipTimeCode(hours: 0, minutes: 0, seconds: 0, milliseconds: 0)
        let timeCodeWithLowValue = SubRipTimeCode(hours: 1, minutes: 1, seconds: 1, milliseconds: 1)
        let timeCodeWithStandardValue = SubRipTimeCode(hours: 1, minutes: 35, seconds: 13, milliseconds: 666)
        let timeCodeWithBigValue = SubRipTimeCode(hours: 59, minutes: 59, seconds: 59, milliseconds: 999)
        
        XCTAssertEqual(timeCodeWithZeroValue!.totalNumberOfMilliseconds, 0)
        XCTAssertEqual(timeCodeWithLowValue!.totalNumberOfMilliseconds, 3_661_001)
        XCTAssertEqual(timeCodeWithStandardValue!.totalNumberOfMilliseconds, 5_713_666)
        XCTAssertEqual(timeCodeWithBigValue!.totalNumberOfMilliseconds, 215_999_999)
    }
    
    func testSubRipTimeCodeFormattedValue() {
        let timeCodeWithZeroValue = SubRipTimeCode(hours: 0, minutes: 0, seconds: 0, milliseconds: 0)
        let timeCodeWithLowValue = SubRipTimeCode(hours: 0, minutes: 0, seconds: 0, milliseconds: 1)
        let timeCodeWithStandardValue = SubRipTimeCode(hours: 1, minutes: 35, seconds: 13, milliseconds: 666)
        let timeCodeWithMaxValue = SubRipTimeCode(hours: 59, minutes: 59, seconds: 59, milliseconds: 999)
        
        XCTAssertEqual(timeCodeWithZeroValue?.formattedString(), "00:00:00,000")
        XCTAssertEqual(timeCodeWithLowValue?.formattedString(), "00:00:00,001")
        XCTAssertEqual(timeCodeWithStandardValue?.formattedString(), "01:35:13,666")
        XCTAssertEqual(timeCodeWithMaxValue?.formattedString(), "59:59:59,999")
    }
    
    func testSubRipSubtitleFormatFormattedString() {
        let subRipTimeCode1 = SubRipTimeCode(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)!
        let subRipTimeCode2 = SubRipTimeCode(hours: 2, minutes: 3, seconds: 33, milliseconds: 40)!
        
        let someText = ["You know nothing!", "John Snow..."]
        
        let correctSRT = SubRipSubtitleFormat(textNumber: 2, startTimeCode: subRipTimeCode1, endTimeCode: subRipTimeCode2, linesOfText: someText)
        let expectedSRTFormat =
            "2\n" +
            "01:02:03,004 --> 02:03:33,040\n" +
            "You know nothing!\n" +
            "John Snow...\n" +
            "\n"
        XCTAssertEqual(correctSRT.formattedString(), expectedSRTFormat)
    }
    
}
