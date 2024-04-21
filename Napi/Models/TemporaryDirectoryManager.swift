//
//  Created by Mateusz Karwat on 12/12/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation
import OSLog

/// Provides an easy and clean way to access and manage temporary directory.
final class TemporaryDirectoryManager {
    private let fileManager = FileManager.default
    private let logger = Logger(category: "TemporaryDirectoryManager")

    let temporaryDirectory: URL

    /// Creates a new instance of `TemporaryDirectoryManager`.
    ///
    /// - Parameter folderName: Name of directory to be created.
    init(directoryName: String) {
        temporaryDirectory = fileManager.temporaryDirectory.appendingPathComponent(directoryName, isDirectory: true)
    }

    /// Creates a new instance of `TemporaryDirectoryManager` with default directory name.
    class var `default`: TemporaryDirectoryManager {
        return TemporaryDirectoryManager(directoryName: Bundle.main.bundleIdentifier ??
            Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String)
    }

    /// Checks if temporary directory is empty.
    var temporaryDirectoryIsEmpty: Bool {
        return contentsOfTemporaryDirectory.isEmpty
    }

    /// Checks if temporary directory exists.
    var temporaryDirectoryExists: Bool {
        return fileManager.fileExists(atPath: temporaryDirectory.path)
    }

    /// Tries to create temporary directory.
    func createTemporaryDirectory() {
        if !temporaryDirectory.exists {
            do {
                logger.info("Creating temporary directory.")
                try fileManager.createDirectory(at: temporaryDirectory, withIntermediateDirectories: false, attributes: nil)
            } catch let error {
                logger.error("\(error.localizedDescription)")
            }
        }
    }

    /// Returns paths to all files and directories inside temporary directory.
    var contentsOfTemporaryDirectory: [URL] {
        do {
            return try fileManager.contentsOfDirectory(at: temporaryDirectory, includingPropertiesForKeys: nil, options: [])
        } catch let error {
            logger.error("\(error.localizedDescription)")
            return []
        }
    }

    /// Removes temporary directory with all its content.
    func removeTemporaryDirectory() {
        if temporaryDirectory.exists {
            do {
                logger.info("Removing temporary directory.")
                try fileManager.removeItem(at: temporaryDirectory)
            } catch let error {
                logger.error("\(error.localizedDescription)")
            }
        }
    }

    /// Removes all files and directories inside temporary directory.
    func cleanupTemporaryDirectory() {
        contentsOfTemporaryDirectory.forEach {
            do {
                logger.info("Cleaning temporary directory.")
                try fileManager.removeItem(at: $0)
            } catch let error {
                logger.error("\(error.localizedDescription)")
            }
        }
    }
}
