//
//  Created by Mateusz Karwat on 24/04/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

extension Array {

    /// Removes an element from a specific index
    /// and inserts it at the new one.
    ///
    /// - Parameters:
    ///   - from: Position of an element to move.
    ///   - to:   New position of an element.
    mutating func move(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }

    /// Removes all elements at specified positions
    /// and returns them. It does not crash if an index
    /// is out of bounds. If it happens index is just ignored.
    ///
    /// - Parameter indexes: A set of indexes to remove.
    ///
    /// - Returns: `Array` of all removed elements.
    ///            Please note that its count might be <= than a count 
    ///            of `indexes`.
    mutating func removeElements(at indexes: IndexSet) -> [Element] {
        let sortedAndReversedIndexes = indexes.sorted().reversed()
        var removedElements = [Element]()

        sortedAndReversedIndexes.forEach { index in
            if startIndex ..< endIndex ~= index {
                let removedElement = remove(at: index)
                removedElements.insert(removedElement, at: 0)
            }
        }

        return removedElements
    }
}
