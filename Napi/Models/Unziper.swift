//
//  Created by Mateusz Karwat on 30/11/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Utility struct to extract compressed files.
struct Unziper {

    /// Extract compressed files in an archive using `unzip` command line.
    ///
    /// - Parameters:
    ///   - fileURL:     A `URL` to the archive.
    ///   - destination: A directory the archive should be extracted to.
    ///   - overwrite:   If it's set to `true` all exisiting files will be replaced in case of collision.
    ///   - password:    A password to the archive.
    static func unzipFile(at fileURL: URL, to destination: URL? = nil, overwrite: Bool = false, password: String? = nil) {
        guard fileURL.isFile, fileURL.exists else { return }

        let unzipProcess = Process()
        unzipProcess.standardOutput = nil
        unzipProcess.launchPath = "/usr/bin/unzip"
        unzipProcess.currentDirectoryPath = fileURL.deletingLastPathComponent().path
        unzipProcess.arguments = []

        if let password = password {
            unzipProcess.arguments?.append(contentsOf: ["-P", password])
        }

        unzipProcess.arguments?.append(overwrite ? "-o" : "-n")
        unzipProcess.arguments?.append(fileURL.lastPathComponent)

        if let destination = destination {
            unzipProcess.arguments?.append(contentsOf: ["-d", destination.path])
        }

        log.verbose("Unzipping archive.")
        unzipProcess.launch()
        unzipProcess.waitUntilExit()
        log.verbose("Archive has been unzipped.")
    }
}
