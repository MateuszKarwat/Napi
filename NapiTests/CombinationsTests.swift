//
//  Created by Mateusz Karwat on 16/11/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import XCTest
@testable import Napi

class CombinationsTests: XCTestCase {

    let strings = ["A", "B", "C"]
    let numbers = [1, 2, 3]

    func testEmptyLeadingTypes() {
        var generatedCombinations: [(String, Int)] = []
        let allCombinations = Combinations<String, Int>([], numbers)

        for newCombination in allCombinations {
            generatedCombinations.append(newCombination)
        }

        XCTAssertTrue(generatedCombinations.isEmpty)
    }

    func testEmptyFollowingTypes() {
        var generatedCombinations: [(String, Int)] = []
        let allCombinations = Combinations<String, Int>(strings, [])

        for newCombination in allCombinations {
            generatedCombinations.append(newCombination)
        }

        XCTAssertTrue(generatedCombinations.isEmpty)
    }

    func testFilledAllTypes() {
        var generatedCombinations: [(String, Int)] = []
        let allCombinations = Combinations<String, Int>(strings, numbers)

        for newCombination in allCombinations {
            generatedCombinations.append(newCombination)
        }

        let expectedCombinations = [("A", 1), ("A", 2), ("A", 3),
                                    ("B", 1), ("B", 2), ("B", 3),
                                    ("C", 1), ("C", 2), ("C", 3)]

        for (index, combination) in generatedCombinations.enumerated() {
            XCTAssertTrue(combination == expectedCombinations[index])
        }
    }

}
