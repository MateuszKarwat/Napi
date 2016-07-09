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
        let startTimestamp = TS(milliseconds: 99_100)
        let stopTimestamp = TS(milliseconds: 100_000)
        
        let text1 = "It works!|As expected."
        let text2 = "This is one line of sample text"
        
        let expectedStringValue1 = "[991][1000]It works!|As expected."
        let expectedStringValue2 = "[991][1000]This is one line of sample text"
        
        let mplFormat1 = MPL2SubtitleFormat(startTimestamp: startTimestamp, stopTimestamp: stopTimestamp, text: text1)
        XCTAssertEqual(mplFormat1.stringValue(), expectedStringValue1)
        
        let mplFormat2 = MPL2SubtitleFormat(startTimestamp: startTimestamp, stopTimestamp: stopTimestamp, text: text2)
        XCTAssertEqual(mplFormat2.stringValue(), expectedStringValue2)
    }
    
}
