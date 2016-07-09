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
        let regex = try! RegularExpression(pattern: "TEST", options: [])
        let token = Token(type: TestingToken.normal, lexeme: "TEST", pattern: regex)

        XCTAssertEqual([], token.values, "There should be no extra values")
    }

    func testOneValue() {
        let regex = try! RegularExpression(pattern: "T(ES)T", options: [])
        let token = Token(type: TestingToken.normal, lexeme: "TEST", pattern: regex)

        XCTAssertEqual(["ES"], token.values, "There should be no extra values")
    }

    func testMultipleValues() {
        let regex = try! RegularExpression(pattern: "(TE)(ST)", options: [])
        let token = Token(type: TestingToken.normal, lexeme: "TEST", pattern: regex)

        XCTAssertEqual(["TE", "ST"], token.values, "There should be no extra values")
    }
    
}
