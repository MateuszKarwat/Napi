//
//  Created by Mateusz Karwat on 14/01/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

/// A utility class to scan directories in order to find movies
/// and associated subtitles with specific movie.
final class DirectoryScanner {

    /// Returns URLs of all video files in a specific directory.
    ///
    /// - Parameters:
    ///   - path:          A directory to scan.
    ///   - shallowSearch: Perform a shallow search. Do not descend into directories.
    ///
    /// - Returns: URLs of all video files found at `path`.
    class func videoFilesInDirectory(at path: URL, shallowSearch: Bool = false) -> [URL] {
        var videoFiles = [URL]()

        if let enumerator = FileManager.default.enumerator(at: path,
                                                           includingPropertiesForKeys: nil,
                                                           options: shallowSearch ? [.skipsSubdirectoryDescendants] : []) {
            while let file = enumerator.nextObject() as? URL {
                if file.isVideo {
                    videoFiles.append(file)
                }
            }
        }

        return videoFiles
    }

    /// Returns all files which have the same name prefix as a specified file's name.
    ///
    /// - Parameter path: A `URL` to a pattern file.
    ///
    /// - Returns: All files which the same name prefix as a specified file.
    class func associatedFilesWithFile(at path: URL) -> [URL] {
        guard var adjacentFiles = try? FileManager.default.contentsOfDirectory(at: path.deletingLastPathComponent(),
                                                                               includingPropertiesForKeys: nil) else {
            return []
        }

        if let indexOfPatternFile = adjacentFiles.index(of: path) {
            adjacentFiles.remove(at: indexOfPatternFile)
        }

        let patternFileName = path.deletingPathExtension().lastPathComponent // Change
        let associatedFiles = adjacentFiles.filter { $0.deletingPathExtension().lastPathComponent.hasPrefix(patternFileName) } // Change

        return associatedFiles
    }
}


extension DirectoryScanner {

    /// Returns all subtitle files which are associated with specified file.
    ///
    /// - Parameter path: A `URL` to a pattern file.
    ///
    /// - Returns: All subtitle files which are associated with file at `path`.
    class func associatedSubtitlesWithFile(at path: URL) -> [URL] {
        let subtitleFileExtensions = ["txt", "srt"]

        return DirectoryScanner.associatedFilesWithFile(at: path).filter { subtitleFileExtensions.contains($0.pathExtension) }
    }
    
    /// Returns languages of associated files.
    /// Language is determined by checking if remaining suffix of associated file's name
    /// is a correct `isoCode`.
    ///
    /// - Parameter path: A `URL` to a pattern file.
    ///
    /// - Returns: Languages of associated files.
    class func associatedLanguagesWithFile(at path: URL) -> [Language] {
        let associatedFiles = DirectoryScanner.associatedSubtitlesWithFile(at: path)
        var associatedLanguages = [Language]()

        for file in associatedFiles {
            let fileName = file.lastPathComponentWithoutExtension
            let remainingSuffix = fileName.replacingOccurrences(of: path.lastPathComponentWithoutExtension, with: "").trimmingCharacters(in: .punctuationCharacters)

            associatedLanguages.append(Language(isoCode: remainingSuffix))
        }

        return associatedLanguages.filter { $0.name != nil }
    }
}
