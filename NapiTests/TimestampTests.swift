//
//  TimestampTests.swift
//  Napi
//
//  Created by Mateusz Karwat on 31/05/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import XCTest
@testable import Napi

class TimestampTests: XCTestCase {

    func testFrames() {
        // 25.0 FPS
        XCTAssertEqual(TS(frames: 0, frameRate: 25.0).milliseconds, 0)
        XCTAssertEqual(TS(frames: 12, frameRate: 25.0).milliseconds, 480)
        XCTAssertEqual(TS(frames: 25, frameRate: 25.0).milliseconds, 1000)
        XCTAssertEqual(TS(frames: 1_500, frameRate: 25.0).milliseconds, 60_000)
        XCTAssertEqual(TS(frames: 90_000, frameRate: 25.0).milliseconds, 3_600_000)
        XCTAssertEqual(TS(frames: 91_525, frameRate: 25.0).milliseconds, 3_661_000)
        
        // 23.976 FPS
        XCTAssertEqual(TS(frames: 0, frameRate: 23.976).milliseconds, 0)
        XCTAssertEqual(TS(frames: 12, frameRate: 23.976).milliseconds, 501)
        XCTAssertEqual(TS(frames: 25, frameRate: 23.976).milliseconds, 1043)
        XCTAssertEqual(TS(frames: 1_500, frameRate: 23.976).milliseconds, 62_563)
        XCTAssertEqual(TS(frames: 90_000, frameRate: 23.976).milliseconds, 3_753_754)
        XCTAssertEqual(TS(frames: 91_525, frameRate: 23.976).milliseconds, 3_817_359)
    }
    
    func testMilliseconds() {
        // 25.0 FPS
        XCTAssertEqual(TS(milliseconds: 0).numberOfFrames(withFrameRate: 25.0), 0) // Zero seconds
        XCTAssertEqual(TS(milliseconds: 500).numberOfFrames(withFrameRate: 25.0), 13) // Half of a second
        XCTAssertEqual(TS(milliseconds: 1_000).numberOfFrames(withFrameRate: 25.0), 25) // One second
        XCTAssertEqual(TS(milliseconds: 60_000).numberOfFrames(withFrameRate: 25.0), 1_500) // One minute
        XCTAssertEqual(TS(milliseconds: 3_600_000).numberOfFrames(withFrameRate: 25.0), 90_000) // One hour
        XCTAssertEqual(TS(milliseconds: 3_661_000).numberOfFrames(withFrameRate: 25.0), 91_525) // One hour, one minute, one second
        
        // 23.976 FPS
        XCTAssertEqual(TS(milliseconds: 0).numberOfFrames(withFrameRate: 23.976), 0) // Zero seconds
        XCTAssertEqual(TS(milliseconds: 500).numberOfFrames(withFrameRate: 23.976), 12) // Half of a second
        XCTAssertEqual(TS(milliseconds: 1_000).numberOfFrames(withFrameRate: 23.976), 24) // One second
        XCTAssertEqual(TS(milliseconds: 60_000).numberOfFrames(withFrameRate: 23.976), 1_439) // One minute
        XCTAssertEqual(TS(milliseconds: 3_600_000).numberOfFrames(withFrameRate: 23.976), 86_314) // One hour
        XCTAssertEqual(TS(milliseconds: 3_661_000).numberOfFrames(withFrameRate: 23.976), 87_776) // One hour, one minute, one second
    }

    func testSeconds() {
        XCTAssertEqual(TS(seconds: 1).milliseconds, 1_000)

        XCTAssertEqual(TS(milliseconds: 999).numberOfFullSeconds, 0)
        XCTAssertEqual(TS(milliseconds: 1_000).numberOfFullSeconds, 1)
        XCTAssertEqual(TS(milliseconds: 1_001).numberOfFullSeconds, 1)
    }

    func testMinutes() {
        XCTAssertEqual(TS(minutes: 1).milliseconds, 60_000)

        XCTAssertEqual(TS(seconds: 59).numberOfFullMinutes, 0)
        XCTAssertEqual(TS(seconds: 60).numberOfFullMinutes, 1)
        XCTAssertEqual(TS(seconds: 61).numberOfFullMinutes, 1)
    }

    func testHours() {
        XCTAssertEqual(TS(hours: 1).milliseconds, 3_600_000)

        XCTAssertEqual(TS(minutes: 59).numberOfFullHours, 0)
        XCTAssertEqual(TS(minutes: 60).numberOfFullHours, 1)
        XCTAssertEqual(TS(minutes: 61).numberOfFullHours, 1)
    }

}
