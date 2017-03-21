//
//  Created by Mateusz Karwat on 30/11/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

extension URL {

    /// Checks if a URL points to a directory.
    var isDirectory: Bool {
        var isDirectoryFlag: ObjCBool = false
        FileManager.default.fileExists(atPath: self.path, isDirectory: &isDirectoryFlag)
        return isDirectoryFlag.boolValue
    }

    /// Checks if a URL points to a file.
    var isFile: Bool {
        return !self.isDirectory
    }

    /// Checks if a URL points fo a file with a video extension.
    var isVideo: Bool {
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                           self.pathExtension as CFString,
                                                           nil) {
            return UTTypeConformsTo(uti.takeRetainedValue(), kUTTypeMovie)
        }

        return false
    }

    /// Checks if a URL points either to a file or directory which actually exists.
    var exists: Bool {
        return FileManager.default.fileExists(atPath: self.path)
    }

    /// Returns last component of `URL` without extension.
    var lastPathComponentWithoutExtension: String {
        return self.deletingPathExtension().lastPathComponent
    }

    /// Returns a new `URL` which has current date timestamp added to last path component.
    var appendingCurrentDateTimestamp: URL {
        let newName = self.lastPathComponentWithoutExtension + Date().timestamp
        return self.deletingLastPathComponent().appendingPathComponent(newName).appendingPathExtension(self.pathExtension)
    }

    /// Inserts a new path component at the specified position.
    ///
    /// - Parameters:
    ///   - pathComponent: A path component to insert into current path components.
    ///   - index:         The position at which to insert the new path component.
    ///
    /// - Returns: A `URL` with new set of path components.
    ///            If insertion is not possible, the same `URL` will be returned.
    func appendingPathComponent(_ pathComponent: String, at index: Int) -> URL {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }

        var pathComponents = urlComponents.path.components(separatedBy: "/")
        pathComponents.insert(pathComponent, at: min(index, pathComponents.endIndex))
        urlComponents.path = pathComponents.joined(separator: "/")

        return urlComponents.url ?? self
    }
}
