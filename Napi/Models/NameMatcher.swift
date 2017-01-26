//
//  Created by Mateusz Karwat on 17/12/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Error which might occur while matching files.
///
/// - fileAtPatternURLDoesNotExist: `patternURL` points to non-existing file.
/// - fileAtSourceURLDoesNotExist:  `sourceURL` points to non-existing file.
/// - patternURLPointsToADirectory: `patternURL` points to a directory.
enum NameMatchingError: Error {
    case fileAtPatternURLDoesNotExist
    case fileAtSourceURLDoesNotExist
    case patternURLPointsToADirectory
}

/// Utility class to match subtitle file names to a specified file (usually movie).
final class NameMatcher {

    /// Action which should be taken, when name collision appears.
    ///
    /// - cancel:                Do nothing.
    /// - overwrite:             Replace existing item with new one.
    /// - backupDestinationItem: Backup item which already exists at desired location.
    /// - backupSourceItem:      Backup item which is going to be moved.
    enum NameConflictAction {
        case cancel
        case overwrite
        case backupDestinationItem
        case backupSourceItem
    }

    /// Action which should be taken, when name collision appears.
    /// For backup files ISO-8601 timestamp is appended.
    var nameConflictAction = NameConflictAction.backupDestinationItem

    /// Appends ISO-639 code representation of language at the end of filename if set to `true`.
    /// Do nothing otherwise.
    var appendLanguageCode = true

    /// Returns a name which matches `patternURL`'s filename.
    ///
    /// - Parameters:
    ///   - subtitleEntity: `SubtitleEntity` which local file should be renamed.
    ///   - patternURL:     A `URL` to a file which name should be taken as a basename.
    ///
    /// - Returns: A name which matches `patternURL`'s filename.
    ///
    /// - Throws: `NameMatchingError`.
    func name(for subtitleEntity: SubtitleEntity, matchingFileAt patternURL: URL) throws -> String {
        guard patternURL.exists else { throw NameMatchingError.fileAtPatternURLDoesNotExist }
        guard patternURL.isFile else { throw NameMatchingError.patternURLPointsToADirectory }

        var constructedName = patternURL.lastPathComponentWithoutExtension

        if appendLanguageCode {
            constructedName.append(".\(subtitleEntity.language.isoCode)")
        }

        return constructedName
    }

    /// Moves file from `SubtitleEntity` to the `patternURL`'s destination
    /// and renames files based on `nameConflictAction`.
    ///
    /// - Parameters:
    ///   - subtitleEntity: `SubtitleEntity` which local file should be moved.
    ///   - patternURL:     A `URL` to a file which name should be taken as a basename.
    ///
    /// - Throws: `NameMatchingError` or `FileManager`'s error.
    func move(_ subtitleEntity: SubtitleEntity, toMatchFileAt patternURL: URL) throws {
        let sourceURL = subtitleEntity.url

        guard sourceURL.exists, sourceURL.isFile else {
            throw NameMatchingError.fileAtSourceURLDoesNotExist
        }

        let destinationDirectory = patternURL.deletingLastPathComponent()
        let destinationName = try name(for: subtitleEntity, matchingFileAt: patternURL)
        let fileExtension = sourceURL.pathExtension

        var destinationURL = destinationDirectory.appendingPathComponent(destinationName)

        if !fileExtension.isEmpty {
            destinationURL.appendPathExtension(fileExtension)
        }

        if destinationURL.exists {
            switch nameConflictAction {
            case .overwrite, .backupDestinationItem:
                try FileManager.default.replaceItem(at: destinationURL,
                                                    withItemAt: sourceURL,
                                                    backupItemName: destinationURL.appendingCurrentDateTimestamp.lastPathComponent,
                                                    options: nameConflictAction == .backupDestinationItem ? [.withoutDeletingBackupItem] : [],
                                                    resultingItemURL: nil)
            case .backupSourceItem:
                try FileManager.default.moveItem(at: sourceURL, to: destinationURL.appendingCurrentDateTimestamp)
            default:
                return
            }
        } else {
            try FileManager.default.moveItem(at: sourceURL, to: destinationURL)
        }
    }
}
