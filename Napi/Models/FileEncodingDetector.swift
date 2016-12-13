//
//  Created by Mateusz Karwat on 13/12/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Utility struct with methods to detect encoding of files.
struct FileEncodingDetector {

    /// Tries to detect an encoding of a file.
    ///
    /// - Parameter fileURL: A `URL` to a file which encoding needs to be detected.
    ///
    /// - Returns: A detected string encoding. Returns `nil` for example
    ///   if file doesn't exist or contents of a file cannot be loaded.
    ///
    /// - Note: It doesn't guarantee to always return correct and best encoding.
    ///   It's important to check if content with detected encoding can be correctly
    ///   read and processed. Best results are for Polish language, which initially
    ///   is the main language of this application.
    static func detectEncodingOfFile(at fileURL: URL) -> String.Encoding? {
        guard fileURL.isFile, fileURL.exists else {
            return nil
        }

        // Try to detect encoding using standard `String` method.
        var detectedEncoding: String.Encoding = .isoLatin1
        if let _ = try? String(contentsOf: fileURL, usedEncoding: &detectedEncoding) {
            return detectedEncoding
        }

        guard let fileData = try? Data(contentsOf: fileURL) else {
            return nil
        }

        // Extra set of characters to strengthen encoding detection in Polish texts.
        let charactersToCount: [Character] = ["ą", "ć", "ź", "ł", "ó", "ę", "ń", "ż"]

        // A set of most common encodings to try if standard detection fails.
        let possibleEncodings: [String.Encoding] = [.isoLatin1, .windowsCP1250, .windowsCP1252, .utf8]

        var bestNumberOfMatches = 0
        for possibleEncoding in possibleEncodings {
            var currentNumberOfMatches = 0
            if let encodedString = String(data: fileData, encoding: possibleEncoding) {
                if bestNumberOfMatches == 0 {
                    detectedEncoding = possibleEncoding
                }

                for character in charactersToCount {
                    if encodedString.characters.contains(character) {
                        currentNumberOfMatches += 1
                    }
                }

                if currentNumberOfMatches > bestNumberOfMatches {
                    detectedEncoding = possibleEncoding
                    bestNumberOfMatches = currentNumberOfMatches
                }
            }
        }
        
        return detectedEncoding
    }
}
