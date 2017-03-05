//
//  Created by Mateusz Karwat on 05/03/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

/// A Boolean value indicating whether the collection is not empty.
///
/// - Complexity: O(1)
extension Collection {
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
}
