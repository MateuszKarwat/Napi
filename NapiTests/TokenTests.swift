//
//  TokenTests.swift
//  Napi
//
//  Created by Mateusz Karwat on 08/07/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import XCTest
@testable import Napi

class TokenTests: XCTestCase {

    enum TestingToken: String {
        case normal
    }
    
    func testEmptyValues() {
        let regex = try! NSRegularExpression(pattern: "TEST", options: [])
        let token = Token(type: TestingToken.normal, lexeme: "TEST", pattern: regex)

        XCTAssertTrue(token.values.isEmpty, "There should be no extra values")
    }

    func testOneValue() {
        let regex = try! NSRegularExpression(pattern: "T(ES)T", options: [])
        let token = Token(type: TestingToken.normal, lexeme: "TEST", pattern: regex)

        XCTAssertEqual(["ES"], token.values)
    }

    func testMultipleValues() {
        let regex = try! NSRegularExpression(pattern: "(TE)(ST)", options: [])
        let token = Token(type: TestingToken.normal, lexeme: "TEST", pattern: regex)

        XCTAssertEqual(["TE", "ST"], token.values)
    }
    
}
