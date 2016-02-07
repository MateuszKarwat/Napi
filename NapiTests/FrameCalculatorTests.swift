//
//  FrameCalculatorTests.swift
//  Napi
//
//  Created by Mateusz Karwat on 07/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import XCTest

class FrameCalculatorTests: XCTestCase {

    func testFrameCalculatorFramesConversion() {
        // 25.0 FPS
        XCTAssertEqual(FrameCalculator.framesToMilliseconds(0, withFrameRate: 25.0), 0)
        XCTAssertEqual(FrameCalculator.framesToMilliseconds(12, withFrameRate: 25.0), 480)
        XCTAssertEqual(FrameCalculator.framesToMilliseconds(25, withFrameRate: 25.0), 1000)
        XCTAssertEqual(FrameCalculator.framesToMilliseconds(1_500, withFrameRate: 25.0), 60_000)
        XCTAssertEqual(FrameCalculator.framesToMilliseconds(90_000, withFrameRate: 25.0), 3_600_000)
        XCTAssertEqual(FrameCalculator.framesToMilliseconds(91_525, withFrameRate: 25.0), 3_661_000)
        
        // 23.976 FPS
        XCTAssertEqual(FrameCalculator.framesToMilliseconds(0, withFrameRate: 23.976), 0)
        XCTAssertEqual(FrameCalculator.framesToMilliseconds(12, withFrameRate: 23.976), 501)
        XCTAssertEqual(FrameCalculator.framesToMilliseconds(25, withFrameRate: 23.976), 1043)
        XCTAssertEqual(FrameCalculator.framesToMilliseconds(1_500, withFrameRate: 23.976), 62_563)
        XCTAssertEqual(FrameCalculator.framesToMilliseconds(90_000, withFrameRate: 23.976), 3_753_754)
        XCTAssertEqual(FrameCalculator.framesToMilliseconds(91_525, withFrameRate: 23.976), 3_817_359)
    }
    
    func testFrameCalculatorMillisecondsConversion() {
        // 25.0 FPS
        XCTAssertEqual(FrameCalculator.millisecondsToFrames(0, withFrameRate: 25.0), 0) // Zero seconds
        XCTAssertEqual(FrameCalculator.millisecondsToFrames(500, withFrameRate: 25.0), 13) // Half of a second
        XCTAssertEqual(FrameCalculator.millisecondsToFrames(1_000, withFrameRate: 25.0), 25) // One second
        XCTAssertEqual(FrameCalculator.millisecondsToFrames(60_000, withFrameRate: 25.0), 1_500) // One minute
        XCTAssertEqual(FrameCalculator.millisecondsToFrames(3_600_000, withFrameRate: 25.0), 90_000) // One hour
        XCTAssertEqual(FrameCalculator.millisecondsToFrames(3_661_000, withFrameRate: 25.0), 91_525) // One hour, one minute, one second
        
        // 23.976 FPS
        XCTAssertEqual(FrameCalculator.millisecondsToFrames(0, withFrameRate: 23.976), 0) // Zero seconds
        XCTAssertEqual(FrameCalculator.millisecondsToFrames(500, withFrameRate: 23.976), 12) // Half of a second
        XCTAssertEqual(FrameCalculator.millisecondsToFrames(1_000, withFrameRate: 23.976), 24) // One second
        XCTAssertEqual(FrameCalculator.millisecondsToFrames(60_000, withFrameRate: 23.976), 1_439) // One minute
        XCTAssertEqual(FrameCalculator.millisecondsToFrames(3_600_000, withFrameRate: 23.976), 86_314) // One hour
        XCTAssertEqual(FrameCalculator.millisecondsToFrames(3_661_000, withFrameRate: 23.976), 87_776) // One hour, one minute, one second
    }

}
