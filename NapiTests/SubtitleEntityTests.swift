//
//  Created by Mateusz Karwat on 16/12/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import XCTest
@testable import Napi

class SubtitleEntityTests: XCTestCase {

    func testUniqueIDs() {
        var generatedIDs: Set<UUID> = []

        for _ in 0 ..< 10 {
            let language = Language(isoCode: "pl")
            let subtitleEntity = SubtitleEntity(language: language, format: .text)
            let id = subtitleEntity.id

            XCTAssertFalse(generatedIDs.contains(id), "\(id) has been generated at least twice.")

            generatedIDs.insert(subtitleEntity.id)
        }

        XCTAssertEqual(generatedIDs.count, 10)
    }

    func testTemporaryPathWithoutFormatExtension() {
        let language = Language(isoCode: "en")
        var subtitleEntity = SubtitleEntity(language: language, format: .text)

        let expectedURL = TemporaryDirectoryManager.default.temporaryDirectory.appendingPathComponent(subtitleEntity.id.uuidString)

        XCTAssertEqual(subtitleEntity.temporaryPathWithoutFormatExtension, expectedURL)

        subtitleEntity.format = .archive

        XCTAssertEqual(subtitleEntity.temporaryPathWithoutFormatExtension, expectedURL)
    }

    func testTemporaryPathWithFormatExtension() {
        let language = Language(isoCode: "en")
        var subtitleEntity = SubtitleEntity(language: language, format: .text)

        let expectedURL = TemporaryDirectoryManager.default.temporaryDirectory.appendingPathComponent(subtitleEntity.id.uuidString)

        XCTAssertEqual(subtitleEntity.temporaryPathWithFormatExtension, expectedURL.appendingPathExtension("text"))

        subtitleEntity.format = .archive

        XCTAssertEqual(subtitleEntity.temporaryPathWithFormatExtension, expectedURL.appendingPathExtension("archive"))
    }
    
}
