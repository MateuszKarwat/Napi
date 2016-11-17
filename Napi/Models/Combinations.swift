//
//  Created by Mateusz Karwat on 17/11/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

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
