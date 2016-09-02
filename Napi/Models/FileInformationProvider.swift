//
//  FileInformationProvider.swift
//  Napi
//
//  Created by Mateusz Karwat on 28/08/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Represents a struct which provides various informations
/// about a file, such a size or checksum.
struct FileInformationProvider {
    let url: URL

    /// Creates an instance of `FileInformationProvider`.
    /// Fails if file at specified URL doesn't exist.
    ///
    /// - Parameter url: A URL to a file.
    init?(url: URL) {
        guard FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }

        self.url = url
    }

    /// Returns a size of a file in bytes.
    /// If file doesn't exist or cannot access its size value, returns 0.
    var fileSize: Int {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: url.path)
            return fileAttributes[.size] as? Int ?? 0
        } catch {
            return 0
        }
    }

    /// Hash code is based on ​Media Player Classic.
    /// In natural language it calculates: size + 64bit checksum of the first and last 64KB
    /// (even if they overlap because the file is smaller than 128KB).
    /// It guaranteed to have exactly 16 characters.
    var checksum: String? {
        let chunkSize = 65536
        let uInt64Size = MemoryLayout<UInt64>.size
        
        guard let fileHandler = try? FileHandle(forReadingFrom: url) else {
            return nil
        }

        defer { fileHandler.closeFile() }

        let fileDataBegin = fileHandler.readData(ofLength: chunkSize)

        fileHandler.seekToEndOfFile()
        let fileSize: UInt64 = fileHandler.offsetInFile

        fileHandler.seek(toFileOffset: max(0, fileSize - UInt64(chunkSize)))
        let fileDataEnd = fileHandler.readData(ofLength: chunkSize)

        var result: UInt64 = fileSize
        fileDataBegin.withUnsafeBytes { (bytes: UnsafePointer<UInt64>) -> Void in
            let dataBytes = UnsafeBufferPointer<UInt64>(start: bytes, count: fileDataBegin.count / uInt64Size)
            result = dataBytes.reduce(result, &+)
        }

        fileDataEnd.withUnsafeBytes { (bytes: UnsafePointer<UInt64>) -> Void in
            let dataBytes = UnsafeBufferPointer<UInt64>(start: bytes, count: fileDataEnd.count / uInt64Size)
            result = dataBytes.reduce(result, &+)
        }

        var resultString = String(format: "%qx", result)

        // Make sure it has 16 character. Otherwise add zeros at the beginning.
        for _ in 0 ..< 16 - resultString.characters.count {
            resultString.insert("0", at: resultString.startIndex)
        }

        return resultString
    }

    /// Produces MD5 hash value of a file.
    /// If `chunkSize` is greater than 0, then MD5 hash value
    /// is calculated based on first `chunkSize` bytes.
    /// Entire data is taken in any other case.
    ///
    /// - Parameter chunkSize: Number of first bytes passed
    ///   to hashing function.
    ///
    /// - Returns: 128-bit hash value.
    func md5(chunkSize: Int? = nil) -> String? {
        if
            let chunkSize = chunkSize,
            let fileHandler = try? FileHandle(forReadingFrom: url),
            chunkSize > 0 {
            return fileHandler.readData(ofLength: chunkSize).md5
        }

        return try? Data(contentsOf: url).md5
    }
}
