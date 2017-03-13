//
//  Created by Mateusz Karwat on 28/08/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation
import AVFoundation

/// Represents a struct which provides various informations
/// about a file, such a size or checksum.
struct FileInformation {
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

    /// Returns file name with extension.
    var name: String {
        return url.lastPathComponent
    }

    /// Returns a size of a file in bytes.
    /// If file doesn't exist or cannot access its size value, returns 0.
    var size: Int {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: url.path)
            return fileAttributes[.size] as? Int ?? 0
        } catch {
            return 0
        }
    }

    /// Tries to detect an encoding of a file.
    ///
    /// - Returns: A detected string encoding and decoded content. Returns `nil` for example
    ///   if file doesn't exist or contents of a file cannot be loaded.
    ///
    /// - Note: It doesn't guarantee to always return correct and best encoding.
    ///   It's important to check if content with detected encoding can be correctly
    ///   read and processed. Best results are for Polish language, which initially
    ///   is the main target language of this application.
    var encodedString: (string: String, encoding: String.Encoding)? {
        guard url.isFile, url.exists else {
            return nil
        }

        // Try to detect encoding using standard `String` method.
        var detectedEncoding: String.Encoding = .isoLatin1
        if let encodedString = try? String(contentsOf: url, usedEncoding: &detectedEncoding) {
            return (encodedString, detectedEncoding)
        }

        guard let fileData = try? Data(contentsOf: url) else {
            return nil
        }

        // Extra set of characters to strengthen encoding detection in Polish texts.
        let charactersToCount: [Character] = ["ą", "ć", "ź", "ł", "ó", "ę", "ń", "ż"]

        // A set of most common encodings to try if standard detection fails.
        let possibleEncodings: [String.Encoding] = [.isoLatin1, .windowsCP1250, .windowsCP1252, .utf8]

        var encodedString: String?
        var bestNumberOfMatches = 0

        for possibleEncoding in possibleEncodings {
            var currentNumberOfMatches = 0
            if let content = String(data: fileData, encoding: possibleEncoding) {
                if bestNumberOfMatches == 0 {
                    encodedString = content
                    detectedEncoding = possibleEncoding
                }

                for character in charactersToCount {
                    if content.characters.contains(character) {
                        currentNumberOfMatches += 1
                    }
                }

                if currentNumberOfMatches > bestNumberOfMatches {
                    encodedString = content
                    detectedEncoding = possibleEncoding
                    bestNumberOfMatches = currentNumberOfMatches
                }
            }
        }

        if let encodedString = encodedString {
            return (encodedString, detectedEncoding)
        } else {
            return nil
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

        // Make sure it has 16 characters. Otherwise add zeros at the beginning.
        for _ in 0 ..< 16 - resultString.characters.count {
            resultString.insert("0", at: resultString.startIndex)
        }

        return resultString
    }

    /// Tries to determine `frameRate` of a video file.
    /// If `frameRate` is not possible to find, `nil` is returned.
    var frameRate: Double? {
        let asset = AVAsset(url: url)
        let videoTracks = asset.tracks(withMediaType: AVMediaTypeVideo)

        if let frameRate = videoTracks.first?.nominalFrameRate {
            return Double(frameRate)
        } else {
            return nil
        }
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
            let data = fileHandler.readData(ofLength: chunkSize)
            fileHandler.closeFile()
            return data.md5
        }
        
        return try? Data(contentsOf: url, options: .alwaysMapped).md5
    }
}
