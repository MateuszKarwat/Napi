//
//  Created by Mateusz Karwat on 18/12/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Struct representing all necessary criteria to make a subtitle search.
struct SearchCriteria {

    /// An `URL` to a video file.
    let fileURL: URL

    /// Language of required subtitles.
    let language: Language

    /// Creates a new instance of `SearchCritera`.
    /// Fails if file at `fileURL` doesn't exist or points to a directory.
    init?(fileURL: URL, language: Language) {
        guard fileURL.isFile, fileURL.exists else { return nil }

        self.fileURL = fileURL
        self.language = language
    }
}
