//
//  LexerTests.swift
//  Napi
//
//  Created by Mateusz Karwat on 08/07/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import XCTest
@testable import Napi

class LexerTests: XCTestCase {

    enum TestingToken: String {
        case color
        case bold
        case whitespace
        case word
        case twoValues
    }

    let testingRules: [(String, TestingToken)] = [
        ("Color<([A-Z]+)>", .color),        // Contains one lexeme value
        ("<b>",             .bold),
        (" ",               .whitespace),
        ("(1)(2)",          .twoValues),    // Contains two lexeme values
        ("([a-zA-Z]+)",     .word)          // Contains one lexeme value
    ]

    func testLexWithOneToken() {
        let lexer = Lexer(rules: [("RULE", TestingToken.word)])

        let oneMatch = lexer!.lex(stream: "This should find one RULE")
        XCTAssertEqual([TestingToken.word], oneMatch.map { $0.type }, "There should be only one match")

        let twoMatches = lexer!.lex(stream: "This should find this RULE and thisRULE")
        XCTAssertEqual([TestingToken.word, TestingToken.word], twoMatches.map { $0.type }, "There should be only two matches")
    }

    func testLexWithMultipleTokensAndIncompleteGramma() {
        let lexer = Lexer(rules: testingRules)
        let tokens = lexer!.lex(stream: "12 SampleWord 34<b>Color<BLUE> ")

        let expectedTokenTypes: [TestingToken] = [.twoValues, .whitespace, .word, .whitespace, .bold, .color, .whitespace]

        XCTAssertEqual(expectedTokenTypes, tokens.map { $0.type }, "Token types should be in the same order")
    }

    func testLexWithMultipleTokensAndCompleteGramma() {
        let lexer = Lexer(rules: testingRules)
        let tokens = lexer!.lex(stream: "12 SampleWord <b>Color<BLUE> ")

        let expectedTokenTypes: [TestingToken] = [.twoValues, .whitespace, .word, .whitespace, .bold, .color, .whitespace]

        XCTAssertEqual(expectedTokenTypes, tokens.map { $0.type }, "Token types should be in the same order")
    }

    func testLexWithMultipleTokensButNoMatch() {
        let lexer = Lexer(rules: testingRules)
        let tokens = lexer!.lex(stream: "0987654321")

        XCTAssertTrue(tokens.isEmpty, "There should be no match for a given stream")
    }

    func testLexWithoutTokens() {
        let rules = [(String, TestingToken)]()
        let lexer = Lexer(rules: rules)
        let tokens = lexer!.lex(stream: "This is testing stream")

        XCTAssertTrue(tokens.isEmpty, "With no rules there should be no tokens")
    }
    
}
