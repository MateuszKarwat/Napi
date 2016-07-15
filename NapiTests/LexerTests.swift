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
        let lexer = Lexer(rules: [("RULE", TestingToken.word)])!

        let oneMatch = lexer.lex(stream: "This should find one RULE")
        XCTAssertEqual([TestingToken.word], oneMatch.map { $0.type },
                       "There should be only one match")

        let twoMatches = lexer.lex(stream: "This should find this RULE and thisRULE")
        XCTAssertEqual([TestingToken.word, TestingToken.word], twoMatches.map { $0.type },
                       "There should be two matches")
    }

    func testLexWithMultipleTokensAndIncompleteGramma() {
        let lexer = Lexer(rules: testingRules)!
        let tokens = lexer.lex(stream: "12 SampleWord 34<b>Color<BLUE> ")

        let expectedTokenTypes: [TestingToken] = [.twoValues, .whitespace, .word,
                                                  .whitespace, .bold, .color, .whitespace]

        XCTAssertEqual(expectedTokenTypes, tokens.map { $0.type },
                       "Token types should be in the same order")
    }

    func testLexWithMultipleTokensAndCompleteGramma() {
        let lexer = Lexer(rules: testingRules)!
        let tokens = lexer.lex(stream: "12 SampleWord <b>Color<BLUE> ")

        let expectedTokenTypes: [TestingToken] = [.twoValues, .whitespace, .word,
                                                  .whitespace, .bold, .color, .whitespace]

        XCTAssertEqual(expectedTokenTypes, tokens.map { $0.type },
                       "Token types should be in the same order")
    }

    func testLexWithMultipleTokensButNoMatch() {
        let lexer = Lexer(rules: testingRules)!
        let tokens = lexer.lex(stream: "0987654321")

        XCTAssertTrue(tokens.isEmpty, "There should be no match for a given stream")
    }

    func testLexWithoutTokens() {
        let rules = [(String, TestingToken)]()
        let lexer = Lexer(rules: rules)!
        let tokens = lexer.lex(stream: "This is testing stream")

        XCTAssertTrue(tokens.isEmpty, "With no rules there should be no tokens")
    }
    
}

class LexerAndSubtitleTokenTypeTests: XCTestCase {

    var lexer: Lexer<SubtitleTokenType>!

    override func setUp() {
        super.setUp()

        lexer = Lexer(rules: Lexer<SubtitleTokenType>.defaultSubtitleRules)
    }

    func assertLex(stream: String, expectexType: SubtitleTokenType) {
        let oneResult = lexer.lex(stream: stream)
        XCTAssertEqual(oneResult.first!.type, expectexType)
        XCTAssertEqual(oneResult.first!.lexeme, stream)

        // Check stream made of two equal strings.
        let results = lexer.lex(stream: stream + stream)

        for result in results {
            XCTAssertEqual(result.type, expectexType)
            XCTAssertEqual(result.lexeme, stream)
        }
    }

    func testBoldPattern() {
        assertLex(stream: "{b}", expectexType: .boldStart)
        assertLex(stream: "{y:b}", expectexType: .boldStart)
        assertLex(stream: "<b>", expectexType: .boldStart)

        assertLex(stream: "{/b}", expectexType: .boldEnd)
        assertLex(stream: "{/y:b}", expectexType: .boldEnd)
        assertLex(stream: "</b>", expectexType: .boldEnd)
    }

    func testItalicPattern() {
        assertLex(stream: "{i}", expectexType: .italicStart)
        assertLex(stream: "{y:i}", expectexType: .italicStart)
        assertLex(stream: "<i>", expectexType: .italicStart)

        assertLex(stream: "{/i}", expectexType: .italicEnd)
        assertLex(stream: "{/y:i}", expectexType: .italicEnd)
        assertLex(stream: "</i>", expectexType: .italicEnd)
    }

    func testUnderlinePattern() {
        assertLex(stream: "{u}", expectexType: .underlineStart)
        assertLex(stream: "{y:u}", expectexType: .underlineStart)
        assertLex(stream: "<u>", expectexType: .underlineStart)

        assertLex(stream: "{/u}", expectexType: .underlineEnd)
        assertLex(stream: "{/y:u}", expectexType: .underlineEnd)
        assertLex(stream: "</u>", expectexType: .underlineEnd)
    }

    func testColorPattern() {
        assertLex(stream: "{c:AABBCC}", expectexType: .fontColorStart)
        assertLex(stream: "{c:#AABBCC}", expectexType: .fontColorStart)
        assertLex(stream: "{c:$AABBCC}", expectexType: .fontColorStart)

        assertLex(stream: "{c:RED}", expectexType: .fontColorStart)
        assertLex(stream: "{c:#RED}", expectexType: .fontColorStart)
        assertLex(stream: "{c:$RED}", expectexType: .fontColorStart)

        assertLex(stream: "<font color=\"AABBCC\">", expectexType: .fontColorStart)
        assertLex(stream: "<font color=\"#AABBCC\">", expectexType: .fontColorStart)
        assertLex(stream: "<font color=\"$AABBCC\">", expectexType: .fontColorStart)

        assertLex(stream: "<font color=\"RED\">", expectexType: .fontColorStart)
        assertLex(stream: "<font color=\"#RED\">", expectexType: .fontColorStart)
        assertLex(stream: "<font color=\"$RED\">", expectexType: .fontColorStart)

        assertLex(stream: "{/c}", expectexType: .fontColorEnd)
        assertLex(stream: "</font>", expectexType: .fontColorEnd)
    }

    func testLineSeparatorPattern() {
        assertLex(stream: "\n", expectexType: .newLine)
        assertLex(stream: "|", expectexType: .newLine)
    }

    func testWhitespacePattern() {
        assertLex(stream: " ", expectexType: .whitespace)
        assertLex(stream: "\t", expectexType: .whitespace)
    }

    func testWordPattern() {
        let words = ["WORD", "LONG_LONG_LONG_LONG-WORD", "1234", "!@#}", "WORD1234!@#}"]

        for (index, word) in words.enumerated() {
            let result = lexer.lex(stream: word)
            XCTAssertEqual(result.first!.type, .word)
            XCTAssertEqual(result.first!.lexeme, words[index])
        }
    }

    func testUnknownCharacterPattern() {
        // '{' and '<' are not treated as words. Word can't include them,
        // because they start most common tags, so before them word should end.
        assertLex(stream: "{", expectexType: .unknownCharacter)
        assertLex(stream: "<", expectexType: .unknownCharacter)
    }

    func testAllTokensInOneStream() {
        var partsOfStream = ["{Y:b}", "</B>", "{i}", "{/i}",
                             "<u>", "</U>", "{c:#AABBCC}", "{/c}", "</font>",
                             "|", "\n", " ", "\t", "JUST-SOME-WORDS", "{", "<"]

        var expectedTokens: [SubtitleTokenType] = [.boldStart, .boldEnd, .italicStart, .italicEnd,
                                                   .underlineStart, .underlineEnd, .fontColorStart,
                                                   .fontColorEnd, .fontColorEnd, .newLine, .newLine,
                                                   .whitespace, .whitespace, .word, .unknownCharacter,
                                                   .unknownCharacter]

        let streamInParsingOrder = partsOfStream.joined(separator: "")
        for (index, result) in lexer.lex(stream: streamInParsingOrder).enumerated() {
            XCTAssertEqual(result.type, expectedTokens[index])
            XCTAssertEqual(result.lexeme, partsOfStream[index])
        }

        // Test the same stream, but elements now are reversed.
        expectedTokens.reverse()
        partsOfStream.reverse()

        let streamInReverseToParsingOrder = partsOfStream.joined(separator: "")
        for (index, result) in lexer.lex(stream: streamInReverseToParsingOrder).enumerated() {
            XCTAssertEqual(result.type, expectedTokens[index])
            XCTAssertEqual(result.lexeme, partsOfStream[index])
        }
    }

    func testCornerCases() {
        // Test empty stream.
        let noResults = lexer.lex(stream: "")
        XCTAssertTrue(noResults.isEmpty)

        // Test something what starts like a tag, but it's not.
        let notRealTags = lexer.lex(stream: "{n}{/x}<font>")
        let expectedTokens: [SubtitleTokenType] = [.unknownCharacter, .word,
                                                   .unknownCharacter, .word,
                                                   .unknownCharacter, .word]
        let expectedLexemes = ["{", "n}", "{", "/x}", "<", "font>"]

        for (index, result) in notRealTags.enumerated() {
            XCTAssertEqual(result.type, expectedTokens[index])
            XCTAssertEqual(result.lexeme, expectedLexemes[index])
        }
    }

}
