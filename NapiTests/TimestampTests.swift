//
//  TimestampTests.swift
//  Napi
//
//  Created by Mateusz Karwat on 31/05/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import XCTest

class TimestampTests: XCTestCase {

    func testFramesConversion() {
        // 25.0 FPS
        XCTAssertEqual(Timestamp(frames: 0, frameRate: 25.0).milliseconds, 0)
        XCTAssertEqual(Timestamp(frames: 12, frameRate: 25.0).milliseconds, 480)
        XCTAssertEqual(Timestamp(frames: 25, frameRate: 25.0).milliseconds, 1000)
        XCTAssertEqual(Timestamp(frames: 1_500, frameRate: 25.0).milliseconds, 60_000)
        XCTAssertEqual(Timestamp(frames: 90_000, frameRate: 25.0).milliseconds, 3_600_000)
        XCTAssertEqual(Timestamp(frames: 91_525, frameRate: 25.0).milliseconds, 3_661_000)
        
        // 23.976 FPS
        XCTAssertEqual(Timestamp(frames: 0, frameRate: 23.976).milliseconds, 0)
        XCTAssertEqual(Timestamp(frames: 12, frameRate: 23.976).milliseconds, 501)
        XCTAssertEqual(Timestamp(frames: 25, frameRate: 23.976).milliseconds, 1043)
        XCTAssertEqual(Timestamp(frames: 1_500, frameRate: 23.976).milliseconds, 62_563)
        XCTAssertEqual(Timestamp(frames: 90_000, frameRate: 23.976).milliseconds, 3_753_754)
        XCTAssertEqual(Timestamp(frames: 91_525, frameRate: 23.976).milliseconds, 3_817_359)
    }
    
    func testMillisecondsConversion() {
        // 25.0 FPS
        XCTAssertEqual(Timestamp(milliseconds: 0).numberOfFrames(withFrameRate: 25.0), 0) // Zero seconds
        XCTAssertEqual(Timestamp(milliseconds: 500).numberOfFrames(withFrameRate: 25.0), 13) // Half of a second
        XCTAssertEqual(Timestamp(milliseconds: 1_000).numberOfFrames(withFrameRate: 25.0), 25) // One second
        XCTAssertEqual(Timestamp(milliseconds: 60_000).numberOfFrames(withFrameRate: 25.0), 1_500) // One minute
        XCTAssertEqual(Timestamp(milliseconds: 3_600_000).numberOfFrames(withFrameRate: 25.0), 90_000) // One hour
        XCTAssertEqual(Timestamp(milliseconds: 3_661_000).numberOfFrames(withFrameRate: 25.0), 91_525) // One hour, one minute, one second
        
        // 23.976 FPS
        XCTAssertEqual(Timestamp(milliseconds: 0).numberOfFrames(withFrameRate: 23.976), 0) // Zero seconds
        XCTAssertEqual(Timestamp(milliseconds: 500).numberOfFrames(withFrameRate: 23.976), 12) // Half of a second
        XCTAssertEqual(Timestamp(milliseconds: 1_000).numberOfFrames(withFrameRate: 23.976), 24) // One second
        XCTAssertEqual(Timestamp(milliseconds: 60_000).numberOfFrames(withFrameRate: 23.976), 1_439) // One minute
        XCTAssertEqual(Timestamp(milliseconds: 3_600_000).numberOfFrames(withFrameRate: 23.976), 86_314) // One hour
        XCTAssertEqual(Timestamp(milliseconds: 3_661_000).numberOfFrames(withFrameRate: 23.976), 87_776) // One hour, one minute, one second
    }
    
}