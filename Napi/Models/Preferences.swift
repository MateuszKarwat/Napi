//
//  Created by Mateusz Karwat on 12/03/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

// This file contains all preferences which are possible to change
// in order to determine application behaviour.
//
// Best way to use these is to access `Preferences` subscript to get
// or set specific preference. For example:
//
//     let showDockIcon = Preferences[.showDockIcon]
//     Preferences[.runInBackground] = false
extension Defaults {

    // Launch parameters

    static let runInBackground                  = DefaultsKey<Bool>("runInBackground")
    static let pathToScan                       = DefaultsKey<String?>("pathToScan")

    // Appearance

    static let showDockIcon                     = DefaultsKey<Bool>("showDockIcon")
    static let showStatusBarItem                = DefaultsKey<Bool>("showStatusBarItem")
    static let postNotifications                = DefaultsKey<Bool>("postNotifications")
    static let showDownloadSummary              = DefaultsKey<Bool>("showDownloadSummary")
    static let closeApplicationWhenFinished     = DefaultsKey<Bool>("closeApplicationWhenFinished")

    // Directory Scanner

    static let shallowSearch                    = DefaultsKey<Bool>("shallowSearch")

    // Subtitle Downloader

    static let languages                        = DefaultsKey<[Language]>("languages")
    static let providers                        = DefaultsKey<[SubtitleProvider]>("providers")
    static let skipAlreadyDownloadedLanguages   = DefaultsKey<Bool>("skipAlreadyDownloadedLanguages")
    static let downloadLimit                    = DefaultsKey<SubtitleDownloader.DownloadLimit>("downloadLimit")

    // Subtitle Converter

    static let changeEncoding                   = DefaultsKey<Bool>("changeEncoding")
    static let expectedEncoding                 = DefaultsKey<String.Encoding>("expectedEncoding")

    static let tryToDetermineFrameRate          = DefaultsKey<Bool>("tryToDetermineFrameRate")
    static let useBackupFrameRate               = DefaultsKey<Bool>("useBackupFrameRate")
    static let backupFrameRate                  = DefaultsKey<Double>("backupFrameRate")

    static let convertSubtitles                 = DefaultsKey<Bool>("convertSubtitles")
    static let expectedSubtitleFormat           = DefaultsKey<SupportedSubtitleFormat>("expectedSubtitleFormat")

    static let correctPunctuation               = DefaultsKey<Bool>("correctPunctuation")
    static let mergeAdjacentWhitespaces         = DefaultsKey<Bool>("mergeAdjacentWhitespaces")

    // Name Matcher

    static let appendLanguageCode               = DefaultsKey<Bool>("appendLanguageCode")
    static let nameConflictAction               = DefaultsKey<NameMatcher.NameConflictAction>("nameConflictAction")
}

// MARK: - Core

let Preferences = UserDefaults.standard

class Defaults {
    fileprivate init() {}
}

class DefaultsKey<ValueType>: Defaults {
    let key: String

    init(_ key: String) {
        self.key = key
    }
}

// MARK: - Subscripts

// Subscripts for easy access to `UserDefaults` and mapping different values.
extension UserDefaults {
    subscript(key: DefaultsKey<Bool>) -> Bool {
        get { return bool(forKey: key.key) }
        set { set(newValue, forKey: key.key) }
    }

    subscript(key: DefaultsKey<String?>) -> String? {
        get { return string(forKey: key.key) }
        set { set(newValue, forKey: key.key) }
    }

    subscript(key: DefaultsKey<Double>) -> Double {
        get { return double(forKey: key.key) }
        set { set(newValue, forKey: key.key) }
    }

    subscript(key: DefaultsKey<SupportedSubtitleFormat>) -> SupportedSubtitleFormat? {
        get { return unarchive(key) }
        set { archive(key, newValue) }
    }

    subscript(key: DefaultsKey<String.Encoding>) -> String.Encoding {
        get { return unarchive(key) ?? .utf8 }
        set { archive(key, newValue) }
    }

    subscript(key: DefaultsKey<NameMatcher.NameConflictAction>) -> NameMatcher.NameConflictAction {
        get { return unarchive(key) ?? .backupDestinationItem }
        set { archive(key, newValue) }
    }

    subscript(key: DefaultsKey<SubtitleDownloader.DownloadLimit>) -> SubtitleDownloader.DownloadLimit {
        get { return unarchive(key) ?? .first }
        set { archive(key, newValue) }
    }

    subscript(key: DefaultsKey<[Language]>) -> [Language] {
        get { return stringArray(forKey: key.key)?.map { Language(isoCode: $0) } ?? [] }
        set { set(newValue.map { $0.isoCode }, forKey: key.key) }
    }

    subscript(key: DefaultsKey<[SubtitleProvider]>) -> [SubtitleProvider] {
        get {
            guard let strings = stringArray(forKey: "providers") else { return [] }
            return strings.flatMap { SupportedSubtitleProvider.provider(withName: $0) }
        }

        set { set(newValue.map { $0.name }, forKey: key.key) }
    }
}

// Helper functions to encode and decode enumerations.
extension UserDefaults {
    func archive<T: RawRepresentable>(_ key: DefaultsKey<T>, _ value: T?) {
        if let value = value {
            set(value.rawValue, forKey: key.key)
        }
    }

    func unarchive<T: RawRepresentable>(_ key: DefaultsKey<T>) -> T? {
        return object(forKey: key.key).flatMap { T(rawValue: $0 as! T.RawValue) }
    }
}
