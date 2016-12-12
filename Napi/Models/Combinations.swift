//
//  Created by Mateusz Karwat on 17/11/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

/// Creates a sequence of combinations from two arrays.
///
/// For example:
///    
///     let combinations = Combinations([1, 2, 3], ["A", "B", "C"])
///     combinations.forEach { print($0) }
///     // Prints: (1, "A"), (1, "B"), (1, "C"), (2, "A"), (2, "B"), ...
struct Combinations<LeadingType, FollowingType>: Sequence, IteratorProtocol {
    typealias Combination = (LeadingType, FollowingType)

    private var remainingCombinations: [Combination]

    init(_ leadingTypes: [LeadingType], _ followingTypes: [FollowingType]) {
        var combinations = [Combination]()

        for leadingType in leadingTypes {
            for followingType in followingTypes {
                combinations.append((leadingType, followingType))
            }
        }

        remainingCombinations = combinations
    }

    mutating func next() -> Combination? {
        if remainingCombinations.isEmpty {
            return nil
        } else {
            return remainingCombinations.remove(at: 0)
        }
    }
}
