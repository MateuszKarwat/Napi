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
            let subtitleEntity = SubtitleEntity(language: language)
            let id = subtitleEntity.id

            XCTAssertFalse(generatedIDs.contains(id), "\(id) has been generated at least twice.")

            generatedIDs.insert(subtitleEntity.id)
        }

        XCTAssertEqual(generatedIDs.count, 10)
    }

    func testDefaultFormatValue() {
        let language = Language(isoCode: "en")
        let subtitleEntity = SubtitleEntity(language: language)

        guard case .remote = subtitleEntity.format else {
            XCTFail()
            return
        }
    }

}
