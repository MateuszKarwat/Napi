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
        XCTAssertEqual(0.frames(frameRate: 25.0).numberOfFull(.milliseconds), 0)
        XCTAssertEqual(12.frames(frameRate: 25.0).numberOfFull(.milliseconds), 480)
        XCTAssertEqual(25.frames(frameRate: 25.0).numberOfFull(.milliseconds), 1000)
        XCTAssertEqual(1_500.frames(frameRate: 25.0).numberOfFull(.milliseconds), 60_000)
        XCTAssertEqual(90_000.frames(frameRate: 25.0).numberOfFull(.milliseconds), 3_600_000)
        XCTAssertEqual(91_525.frames(frameRate: 25.0).numberOfFull(.milliseconds), 3_661_000)

        XCTAssertEqual(0.frames(frameRate: 25.0).roundedValue(in: .milliseconds), 0)
        XCTAssertEqual(12.frames(frameRate: 25.0).roundedValue(in: .milliseconds), 480)
        XCTAssertEqual(25.frames(frameRate: 25.0).roundedValue(in: .milliseconds), 1000)
        XCTAssertEqual(1_500.frames(frameRate: 25.0).roundedValue(in: .milliseconds), 60_000)
        XCTAssertEqual(90_000.frames(frameRate: 25.0).roundedValue(in: .milliseconds), 3_600_000)
        XCTAssertEqual(91_525.frames(frameRate: 25.0).roundedValue(in: .milliseconds), 3_661_000)

        // 23.976 FPS
        XCTAssertEqual(0.frames(frameRate: 23.976).numberOfFull(.milliseconds), 0)
        XCTAssertEqual(12.frames(frameRate: 23.976).numberOfFull(.milliseconds), 500)
        XCTAssertEqual(25.frames(frameRate: 23.976).numberOfFull(.milliseconds), 1042)
        XCTAssertEqual(1_500.frames(frameRate: 23.976).numberOfFull(.milliseconds), 62_562)
        XCTAssertEqual(90_000.frames(frameRate: 23.976).numberOfFull(.milliseconds), 3_753_753)
        XCTAssertEqual(91_525.frames(frameRate: 23.976).numberOfFull(.milliseconds), 3_817_359)

        XCTAssertEqual(0.frames(frameRate: 23.976).roundedValue(in: .milliseconds), 0)
        XCTAssertEqual(12.frames(frameRate: 23.976).roundedValue(in: .milliseconds), 501)
        XCTAssertEqual(25.frames(frameRate: 23.976).roundedValue(in: .milliseconds), 1043)
        XCTAssertEqual(1_500.frames(frameRate: 23.976).roundedValue(in: .milliseconds), 62_563)
        XCTAssertEqual(90_000.frames(frameRate: 23.976).roundedValue(in: .milliseconds), 3_753_754)
        XCTAssertEqual(91_525.frames(frameRate: 23.976).roundedValue(in: .milliseconds), 3_817_359)
    }
    
    func testMilliseconds() {
        // 25.0 FPS
        XCTAssertEqual(0.milliseconds.numberOfFull(.frames(frameRate: 25.0)), 0) // Zero seconds
        XCTAssertEqual(500.milliseconds.numberOfFull(.frames(frameRate: 25.0)), 12) // Half of a second
        XCTAssertEqual(1_000.milliseconds.numberOfFull(.frames(frameRate: 25.0)), 25) // One second
        XCTAssertEqual(60_000.milliseconds.numberOfFull(.frames(frameRate: 25.0)), 1_500) // One minute
        XCTAssertEqual(3_600_000.milliseconds.numberOfFull(.frames(frameRate: 25.0)), 90_000) // One hour
        XCTAssertEqual(3_661_000.milliseconds.numberOfFull(.frames(frameRate: 25.0)), 91_525) // One hour, one minute, one second

        XCTAssertEqual(0.milliseconds.roundedValue(in: .frames(frameRate: 25.0)), 0) // Zero seconds
        XCTAssertEqual(500.milliseconds.roundedValue(in: .frames(frameRate: 25.0)), 13) // Half of a second
        XCTAssertEqual(1_000.milliseconds.roundedValue(in: .frames(frameRate: 25.0)), 25) // One second
        XCTAssertEqual(60_000.milliseconds.roundedValue(in: .frames(frameRate: 25.0)), 1_500) // One minute
        XCTAssertEqual(3_600_000.milliseconds.roundedValue(in: .frames(frameRate: 25.0)), 90_000) // One hour
        XCTAssertEqual(3_661_000.milliseconds.roundedValue(in: .frames(frameRate: 25.0)), 91_525) // One hour, one minute, one second
        
        // 23.976 FPS
        XCTAssertEqual(0.milliseconds.numberOfFull(.frames(frameRate: 23.976)), 0) // Zero seconds
        XCTAssertEqual(500.milliseconds.numberOfFull(.frames(frameRate: 23.976)), 11) // Half of a second
        XCTAssertEqual(1_000.milliseconds.numberOfFull(.frames(frameRate: 23.976)), 23) // One second
        XCTAssertEqual(60_000.milliseconds.numberOfFull(.frames(frameRate: 23.976)), 1_438) // One minute
        XCTAssertEqual(3_600_000.milliseconds.numberOfFull(.frames(frameRate: 23.976)), 86_313) // One hour
        XCTAssertEqual(3_661_000.milliseconds.numberOfFull(.frames(frameRate: 23.976)), 87_776) // One hour, one minute, one second

        XCTAssertEqual(0.milliseconds.roundedValue(in: .frames(frameRate: 23.976)), 0) // Zero seconds
        XCTAssertEqual(500.milliseconds.roundedValue(in: .frames(frameRate: 23.976)), 12) // Half of a second
        XCTAssertEqual(1_000.milliseconds.roundedValue(in: .frames(frameRate: 23.976)), 24) // One second
        XCTAssertEqual(60_000.milliseconds.roundedValue(in: .frames(frameRate: 23.976)), 1_439) // One minute
        XCTAssertEqual(3_600_000.milliseconds.roundedValue(in: .frames(frameRate: 23.976)), 86_314) // One hour
        XCTAssertEqual(3_661_000.milliseconds.roundedValue(in: .frames(frameRate: 23.976)), 87_776) // One hour, one minute, one second
    }

    func testDeciseconds() {
        XCTAssertEqual(1.deciseconds.numberOfFull(.milliseconds), 100)

        XCTAssertEqual(99.milliseconds.numberOfFull(.deciseconds), 0)
        XCTAssertEqual(100.milliseconds.numberOfFull(.deciseconds), 1)
        XCTAssertEqual(101.milliseconds.numberOfFull(.deciseconds), 1)

        XCTAssertEqual(99.milliseconds.roundedValue(in: .deciseconds), 1)
        XCTAssertEqual(100.milliseconds.roundedValue(in: .deciseconds), 1)
        XCTAssertEqual(101.milliseconds.roundedValue(in: .deciseconds), 1)
    }

    func testSeconds() {
        XCTAssertEqual(1.seconds.numberOfFull(.milliseconds), 1_000)

        XCTAssertEqual(999.milliseconds.numberOfFull(.seconds), 0)
        XCTAssertEqual(1_000.milliseconds.numberOfFull(.seconds), 1)
        XCTAssertEqual(1_001.milliseconds.numberOfFull(.seconds), 1)

        XCTAssertEqual(999.milliseconds.roundedValue(in: .seconds), 1)
        XCTAssertEqual(1_000.milliseconds.roundedValue(in: .seconds), 1)
        XCTAssertEqual(1_001.milliseconds.roundedValue(in: .seconds), 1)
    }

    func testMinutes() {
        XCTAssertEqual(1.minutes.numberOfFull(.milliseconds), 60_000)

        XCTAssertEqual(59.seconds.numberOfFull(.minutes), 0)
        XCTAssertEqual(60.seconds.numberOfFull(.minutes), 1)
        XCTAssertEqual(61.seconds.numberOfFull(.minutes), 1)

        XCTAssertEqual(59.seconds.roundedValue(in: .minutes), 1)
        XCTAssertEqual(60.seconds.roundedValue(in: .minutes), 1)
        XCTAssertEqual(61.seconds.roundedValue(in: .minutes), 1)
    }

    func testHours() {
        XCTAssertEqual(1.hours.numberOfFull(.milliseconds), 3_600_000)

        XCTAssertEqual(59.minutes.numberOfFull(.hours), 0)
        XCTAssertEqual(60.minutes.numberOfFull(.hours), 1)
        XCTAssertEqual(61.minutes.numberOfFull(.hours), 1)

        XCTAssertEqual(59.minutes.roundedValue(in: .hours), 1)
        XCTAssertEqual(60.minutes.roundedValue(in: .hours), 1)
        XCTAssertEqual(61.minutes.roundedValue(in: .hours), 1)
    }

    func testIsFrameBased() {
        XCTAssertTrue(25.frames(frameRate: 25).isFrameBased)

        XCTAssertFalse(10.milliseconds.isFrameBased)
        XCTAssertFalse(10.deciseconds.isFrameBased)
        XCTAssertFalse(10.seconds.isFrameBased)
        XCTAssertFalse(10.minutes.isFrameBased)
        XCTAssertFalse(10.hours.isFrameBased)
    }
}
