//
//  Created by Mateusz Karwat on 03/08/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

enum SubtitleConvertionError: Error {
    case subtitlesNotLoaded
    case subtitleFormatNotSupported
    case frameRateNotSpecified
}

final class SubtitleConverter {

    /// Represents a delay of subtitles in milliseconds.
    var offset = 0

    /// Represents a frame rate of subtitles.
    /// This value is mandatory during the convertion
    /// from frame based format to time based format
    /// and vice versa. It tells how frames should be
    /// calculated to milliseconds and the other way around.
    var frameRate: Double?

    /// Represents a multiplier which should be used,
    /// to change ratio of timestamps. Let's say, you want
    /// to change frame rate of subtitles from 2 to 10.
    /// If so, `frameRateRatio` should be set to 5.
    var frameRateRatio: Double?

    /// If set to `true`, it will force to merge adjacent whitespaces.
    ///
    /// For example:
    ///
    ///     "Ugly   text." -> "Ugly text."
    var mergeAdjacentWhitespaces = false

    /// If set to `true`, it will force to correct punctuation.
    ///
    /// For example:
    ///
    ///     "Ugly , punctuation ." -> "Ugly, punctuation."
    var correctPunctuation = false

    /// Represents a subtitle format detected based on a loaded subtitles.
    private(set) var detectedSubtitleFormat: SupportedSubtitleFormat?

    /// Represent the very same subtitles passed to the `load(subtitles:)` function.
    /// In other words, it represents raw subtitles with no modification.
    private var encodedSubtitles: String?

    /// Tries to detect format of `subtitles` and prepare them for futher conversion.
    ///
    /// - Parameters:
    ///     - subtitles: A `String` with all encoded subtitles.
    ///
    /// - Throws: An error of type `SubtitleConvertionError`.
    ///   * `subtitleFormatNotSupported` if any `SupportedSubtitleFormat`
    ///     can decode given subtitles.
    func load(subtitles: String) throws {
        for format in SupportedSubtitleFormat.allValues {
            if format.type.canDecode(subtitles) {
                encodedSubtitles = subtitles
                detectedSubtitleFormat = format
                return
            }
        }

        throw SubtitleConvertionError.subtitleFormatNotSupported
    }

    /// Returns a `String` with encoded subtitles in specified `SupportedSubtitleFormat`.
    /// 
    /// All options (parameters' values) will be applied if specified.
    ///
    /// - Parameter to: Expected subtitle format of returned `String`.
    ///
    /// - Throws: An error of type `SubtitleConvertionError`.
    ///   * `frameRateNotSpecified` if convertion is from frame based format
    ///     to time based format (or vice versa) and `frameRate` is `nil`.
    ///   * `subtitlesNotLoaded` if no supported subtitles were passed into 
    ///     `load(subtitles:)` function.
    ///
    /// - Returns: `String` with encoded subtitles in specified `SupportedSubtitleFormat`.
    func convert(to subtitleFormat: SupportedSubtitleFormat) throws -> String {
        guard let encodedSubtitles = encodedSubtitles else {
            throw SubtitleConvertionError.subtitlesNotLoaded
        }

        guard let detectedSubtitleFormat = detectedSubtitleFormat else {
            throw SubtitleConvertionError.subtitleFormatNotSupported
        }

        var modifiedSubtitles = [Subtitle]()

        for subtitle in detectedSubtitleFormat.type.decode(encodedSubtitles) {
            var modifiedSubtitle = subtitle

            if detectedSubtitleFormat.type.isTimeBased != subtitleFormat.type.isTimeBased {
                guard let frameRate = frameRate else {
                    throw SubtitleConvertionError.frameRateNotSpecified
                }

                modifiedSubtitle.changeMode(usingFrameRate: frameRate)
            }

            if let frameRateRatio = frameRateRatio { modifiedSubtitle.applyFrameRateRatio(frameRateRatio) }
            if offset != 0 { modifiedSubtitle.addOffet(offset) }
            if mergeAdjacentWhitespaces { modifiedSubtitle.mergeAdjacentWhitespaces() }
            if correctPunctuation { modifiedSubtitle.correctPunctuation() }

            var convertedText = ""
            for token in modifiedSubtitle.tokenizedText {
                if let tokenString = subtitleFormat.type.stringValue(for: token) {
                    convertedText += tokenString
                } else {
                    convertedText += token.lexeme
                }
            }
            modifiedSubtitle.text = convertedText

            modifiedSubtitles.append(modifiedSubtitle)
        }

        return subtitleFormat.type.encode(modifiedSubtitles).joined(separator: "\n")
    }
}

// MARK: - Subtitle Modifications

fileprivate extension Subtitle {

    /// Adds offset specified in milliseconds to startTimestamp and endTimestamp.
    ///
    /// - Parameter offset: Delay specified in milliseconds.
    mutating func addOffet(_ offset: Int) {
        let newStartBaseValue = self.startTimestamp.baseValue + Double(offset)
        let newStopBaseValue = self.stopTimestamp.baseValue + Double(offset)

        self.startTimestamp = Timestamp(baseValue: max(0, newStartBaseValue), unit: self.startTimestamp.unit)
        self.stopTimestamp = Timestamp(baseValue: max(0, newStopBaseValue), unit: self.stopTimestamp.unit)
    }

    /// Changes and recalculates values using given `frameRate`.
    /// If currect unit is time based, it will change it to frame based.
    /// If currect unit is frame based, it will change it to time based.
    ///
    /// - Parameter frameRate: Depending on current units, it specifies
    ///   currect frame rate or expected frame rate.
    mutating func changeMode(usingFrameRate frameRate: Double) {
        if self.startTimestamp.isFrameBased {
            self.startTimestamp = self.startTimestamp.changed(to: .frames(frameRate: frameRate))
        } else {
            self.startTimestamp = self.startTimestamp.converted(to: .frames(frameRate: frameRate))
        }

        if self.stopTimestamp.isFrameBased {
            self.stopTimestamp = self.stopTimestamp.changed(to: .frames(frameRate: frameRate))
        } else {
            self.stopTimestamp = self.stopTimestamp.converted(to: .frames(frameRate: frameRate))
        }
    }

    /// Multiplies `startTimestamp` and `stopTimestamp` by given ratio.
    ///
    /// - Parameter frameRateRatio: A ratio to scale timestamps by.
    mutating func applyFrameRateRatio(_ frameRateRatio: Double) {
        let newStartValue = self.startTimestamp.value * frameRateRatio
        let newStopValue = self.stopTimestamp.value * frameRateRatio

        self.startTimestamp = Timestamp(value: newStartValue, unit: self.startTimestamp.unit)
        self.stopTimestamp = Timestamp(value: newStopValue, unit: self.startTimestamp.unit)
    }

    /// Finds a series of adjacent whitespaces and merge them into single space.
    mutating func mergeAdjacentWhitespaces() {
        let components = self.text.components(separatedBy: CharacterSet.whitespaces)
        self.text = components.filter { $0 != "" }.joined(separator: " ")
    }

    /// Finds all punctuations followed by whitespaces and removes those whitespaces.
    mutating func correctPunctuation() {
        let regex = try! NSRegularExpression(pattern: " +[,|.|?|!|;|:]", options: [])
        let textRange = NSRange(location: 0, length: self.text.characters.count)

        for match in regex.matches(in: self.text, options: [], range: textRange).reversed() {
            let startIndex = self.text.index(self.text.startIndex, offsetBy: match.range.location)
            let endIndex = self.text.index(startIndex, offsetBy: match.range.length - 1)

            self.text.replaceSubrange(startIndex ..< endIndex, with: "")
        }
    }
}
