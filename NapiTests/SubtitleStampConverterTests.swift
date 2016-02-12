//
//  SubtitleStampConverterTests.swift
//  Napi
//
//  Created by Mateusz Karwat on 07/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import XCTest

class SubtitleStampConverterTests: XCTestCase {

    func testFramesConversion() {
        // 25.0 FPS
        XCTAssertEqual(SubtitleStampConverter.millisecondsFromFrames(0, withFrameRate: 25.0), 0)
        XCTAssertEqual(SubtitleStampConverter.millisecondsFromFrames(12, withFrameRate: 25.0), 480)
        XCTAssertEqual(SubtitleStampConverter.millisecondsFromFrames(25, withFrameRate: 25.0), 1000)
        XCTAssertEqual(SubtitleStampConverter.millisecondsFromFrames(1_500, withFrameRate: 25.0), 60_000)
        XCTAssertEqual(SubtitleStampConverter.millisecondsFromFrames(90_000, withFrameRate: 25.0), 3_600_000)
        XCTAssertEqual(SubtitleStampConverter.millisecondsFromFrames(91_525, withFrameRate: 25.0), 3_661_000)
        
        // 23.976 FPS
        XCTAssertEqual(SubtitleStampConverter.millisecondsFromFrames(0, withFrameRate: 23.976), 0)
        XCTAssertEqual(SubtitleStampConverter.millisecondsFromFrames(12, withFrameRate: 23.976), 501)
        XCTAssertEqual(SubtitleStampConverter.millisecondsFromFrames(25, withFrameRate: 23.976), 1043)
        XCTAssertEqual(SubtitleStampConverter.millisecondsFromFrames(1_500, withFrameRate: 23.976), 62_563)
        XCTAssertEqual(SubtitleStampConverter.millisecondsFromFrames(90_000, withFrameRate: 23.976), 3_753_754)
        XCTAssertEqual(SubtitleStampConverter.millisecondsFromFrames(91_525, withFrameRate: 23.976), 3_817_359)
    }
    
    func testMillisecondsConversion() {
        // 25.0 FPS
        XCTAssertEqual(SubtitleStampConverter.framesFromMilliseconds(0, andFrameRate: 25.0), 0) // Zero seconds
        XCTAssertEqual(SubtitleStampConverter.framesFromMilliseconds(500, andFrameRate: 25.0), 13) // Half of a second
        XCTAssertEqual(SubtitleStampConverter.framesFromMilliseconds(1_000, andFrameRate: 25.0), 25) // One second
        XCTAssertEqual(SubtitleStampConverter.framesFromMilliseconds(60_000, andFrameRate: 25.0), 1_500) // One minute
        XCTAssertEqual(SubtitleStampConverter.framesFromMilliseconds(3_600_000, andFrameRate: 25.0), 90_000) // One hour
        XCTAssertEqual(SubtitleStampConverter.framesFromMilliseconds(3_661_000, andFrameRate: 25.0), 91_525) // One hour, one minute, one second
        
        // 23.976 FPS
        XCTAssertEqual(SubtitleStampConverter.framesFromMilliseconds(0, andFrameRate: 23.976), 0) // Zero seconds
        XCTAssertEqual(SubtitleStampConverter.framesFromMilliseconds(500, andFrameRate: 23.976), 12) // Half of a second
        XCTAssertEqual(SubtitleStampConverter.framesFromMilliseconds(1_000, andFrameRate: 23.976), 24) // One second
        XCTAssertEqual(SubtitleStampConverter.framesFromMilliseconds(60_000, andFrameRate: 23.976), 1_439) // One minute
        XCTAssertEqual(SubtitleStampConverter.framesFromMilliseconds(3_600_000, andFrameRate: 23.976), 86_314) // One hour
        XCTAssertEqual(SubtitleStampConverter.framesFromMilliseconds(3_661_000, andFrameRate: 23.976), 87_776) // One hour, one minute, one second
    }
    
    func testTimeBasedToTimeBased() {
        let timeBased = Timestamp(milliseconds: 3_661_000)
        XCTAssertEqual(SubtitleStampConverter.absoluteValueForType(.TimeBased, fromSubtitleStamp: timeBased), 3_661_000)
    }
    
    func testTimeBasedToFrameBased() {
        let timeBased = Timestamp(milliseconds: 3_661_000)
        XCTAssertEqual(SubtitleStampConverter.absoluteValueForType(.FrameBased(FPS: 23.976), fromSubtitleStamp: timeBased), 87_776)
    }
    
    func testFrameBasedToTimeBased() {
        let frameBased = Framestamp(frames: 90_000, frameRate: 25.0)
        XCTAssertEqual(SubtitleStampConverter.absoluteValueForType(.TimeBased, fromSubtitleStamp: frameBased), 3_600_000)
    }
    
    func testFrameBasedToFrameBased() {
        let frameBased = Framestamp(frames: 90_000, frameRate: 25.0)
        XCTAssertEqual(SubtitleStampConverter.absoluteValueForType(.FrameBased(FPS: 23.976), fromSubtitleStamp: frameBased), 86_314)
    }

}