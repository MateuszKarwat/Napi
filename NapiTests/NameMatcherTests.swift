//
//  Created by Mateusz Karwat on 17/12/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import XCTest
@testable import Napi

class NameMatcherTests: XCTestCase {

    func testName() {
        let language = Language(isoCode: "pl")
        let url = Bundle(for: type(of: self)).url(forResource: "MPL2SubtitleFormatFile", withExtension: "txt")!
        let subtitleEntity = SubtitleEntity(language: language, format: .archive)

        let matcher = NameMatcher()
        XCTAssertEqual(try! matcher.name(for: subtitleEntity, matchingFileAt: url), "MPL2SubtitleFormatFile.pl")

        matcher.appendLanguageCode = false
        XCTAssertEqual(try! matcher.name(for: subtitleEntity, matchingFileAt: url), "MPL2SubtitleFormatFile")
    }
    
}
