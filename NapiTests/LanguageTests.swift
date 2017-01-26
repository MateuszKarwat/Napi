//
//  Created by Mateusz Karwat on 15/12/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import XCTest
@testable import Napi

class LanguageTests: XCTestCase {

    func testName() {
        var polishLanguage = Language(isoCode: "pl")
        XCTAssertEqual(polishLanguage.name, "polski")

        polishLanguage.isoCode = "pol"
        XCTAssertEqual(polishLanguage.name, "polski")
    }

    func testCurrentLocaleName() {
        let localizedName = (Locale.current as NSLocale).displayName(forKey: .languageCode, value: "pl")

        var polishLanguage = Language(isoCode: "pl")
        XCTAssertEqual(polishLanguage.currentLocaleName, localizedName)

        polishLanguage.isoCode = "pol"
        XCTAssertEqual(polishLanguage.currentLocaleName, localizedName)
    }

    func testISOCodeLong() {
        let polishLanguage = Language(isoCode: "pl")
        XCTAssertEqual(polishLanguage.isoCodeLong, "pol")
    }

}
