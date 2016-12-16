//
//  Created by Mateusz Karwat on 16/12/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Represents a state of subtitle.
struct SubtitleEntity {

    /// Represents a state in which given `SubtitleEntity` currently is.
    ///
    /// - remote:  Subtitles are not downloaded yet.
    /// - archive: Subtitles are stored locally as a compressed file.
    /// - text:    Subtitles are stored locally in text file.
    enum Format {
        case remote
        case archive(location: URL)
        case text(location: URL)
    }

    /// Unique identifier.
    let id = UUID()

    /// Language of subtitles.
    let language: Language

    /// Current format of subtitles.
    var format = Format.remote

    /// Create a new instance of `SubtitleEntity` with unique `id`
    /// and format set to `remote`.
    ///
    /// - Parameter language: Language of subtitles.
    init(language: Language) {
        self.language = language
        self.format = .remote
    }

    /// Creates a new instance of `SubtitleEntity` with unique `id`.
    ///
    /// - Parameters:
    ///   - language: Language of subtitles.
    ///   - format:   Format of subtitle file.
    init(language: Language, format: Format) {
        self.language = language
        self.format = format
    }
}
