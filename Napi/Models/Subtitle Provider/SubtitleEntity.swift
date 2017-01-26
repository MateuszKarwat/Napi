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
        case archive
        case text

        var pathExtension: String {
            return "\(self)"
        }
    }

    /// Unique identifier.
    let id = UUID()

    /// Language of subtitles.
    let language: Language

    /// Current format of subtitles.
    var format: Format

    /// Location of subtitles.
    var url: URL
}

extension SubtitleEntity {

    /// Convenience initializer to create `SubtitleEntity`
    /// with default temporary location based on its format.
    ///
    /// - Parameters:
    ///   - language: Language of new `SubtitleEntity`.
    ///   - format:   Format of new `SubtitleEntity`.
    init(language: Language, format: Format) {
        self.language = language
        self.format = format
        self.url = TemporaryDirectoryManager.default.temporaryDirectory
            .appendingPathComponent(id.uuidString)
            .appendingPathExtension(format.pathExtension)
    }

    /// Returns a `URL` located at a default `TemporaryDirectory`
    /// with last path component the same as `id`, but with no path extension.
    var temporaryPathWithoutFormatExtension: URL {
        return TemporaryDirectoryManager.default.temporaryDirectory.appendingPathComponent(id.uuidString)
    }

    /// Returns a `URL` located at a default `TemporaryDirectory`
    /// with last path component the same as `id` and path extension based on current `format`.
    var temporaryPathWithFormatExtension: URL {
        return temporaryPathWithoutFormatExtension.appendingPathExtension(format.pathExtension)
    }
}
