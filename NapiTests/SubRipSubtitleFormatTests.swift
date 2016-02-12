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
        let subRipTime1 = TS(hours: 1) + TS(minutes: 2) + TS(seconds: 3) + TS(milliseconds: 4)
        let subRipTime2 = TS(hours: 2) + TS(minutes: 3) + TS(seconds: 33) + TS(milliseconds: 40)
        
        let someText = "You know nothing!\nJohn Snow..."
        
        let correctSRT = SubRipSubtitleFormat(textNumber: 2, startstamp: subRipTime1, stopstamp: subRipTime2, text: someText)
        let expectedSRTFormat =
            "2\n" +
            "01:02:03,004 --> 02:03:33,040\n" +
            "You know nothing!\n" +
            "John Snow...\n" +
            "\n"
        XCTAssertEqual(correctSRT.stringValue(), expectedSRTFormat)
    }
    
}
