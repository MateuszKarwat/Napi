//
//  Created by Mateusz Karwat on 03/08/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Represents a result of matching `SubtitleFormat`'s `regexPattern`
/// in a `String`.
struct SubtitleCheckingResult {

    /// Returns a whole `String` which has been matched.
    var matchedString: String

    /// Returns an `Array` of substring with are extracted from
    /// `matchedString` based on capture groups specified
    /// in `SubtitleFormat`'s `regexPattern`.
    var capturedSubstrings: [String]
}
