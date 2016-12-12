//
//  Created by Mateusz Karwat on 12/12/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import XCTest
@testable import Napi

class TemporaryDirectoryManagerTests: XCTestCase {

    func testAllOperationsOnTemporaryDirectory() {
        let manager = TemporaryDirectoryManager.default

        manager.removeTemporaryDirectory()
        XCTAssertFalse(manager.temporaryDirectoryExists)

        manager.createTemporaryDirectory()
        XCTAssertTrue(manager.temporaryDirectoryExists)
        XCTAssertTrue(manager.temporaryDirectoryIsEmpty)

        let newDirectory = manager.temporaryDirectory.appendingPathComponent("TestDirectory", isDirectory: true)
        try! FileManager.default.createDirectory(at: newDirectory, withIntermediateDirectories: false, attributes: nil)
        XCTAssertTrue(manager.contentsOfTemporaryDirectory.count == 1)

        manager.cleanupTemporaryDirectory()
        XCTAssertTrue(manager.temporaryDirectoryIsEmpty)

        manager.removeTemporaryDirectory()
        XCTAssertFalse(manager.temporaryDirectoryExists)
    }

}
