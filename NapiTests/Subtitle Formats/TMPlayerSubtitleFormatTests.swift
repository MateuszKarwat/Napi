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
        let startTime1 = TS(milliseconds: 3_671_000)
        let startTime2 = TS(milliseconds: 7_271_000)
        
        let sampleText1 = "A long time ago...|In a galaxy far far away..."
        let sampleText2 = "Text which is only one line long"
        
        let expectedStringFormat1 = "01:01:11:A long time ago...|In a galaxy far far away..."
        let expectedStringFormat2 = "02:01:11:Text which is only one line long"
        
        XCTAssertEqual(TMPlayerSubtitleFormat(startTimestamp: startTime1, stopTimestamp: nil, text: sampleText1).stringValue(), expectedStringFormat1)
        XCTAssertEqual(TMPlayerSubtitleFormat(startTimestamp: startTime2, stopTimestamp: nil, text: sampleText2).stringValue(), expectedStringFormat2)
    }

}
