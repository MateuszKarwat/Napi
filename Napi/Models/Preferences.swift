//
//  Created by Mateusz Karwat on 12/03/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

fileprivate let defaults = UserDefaults.standard

/// Utility struct to simplify access to all preferences.
struct Preferences {

    // MARK: - Bool Values

    static var runInBackground: Bool {
        get { return defaults.bool(forKey: "runInBackground") }
        set { defaults.set(newValue, forKey: "runInBackground") }
    }

    static var showDockIcon: Bool {
        get { return defaults.bool(forKey: "showDockIcon") }
        set { defaults.set(newValue, forKey: "showDockIcon") }
    }

    static var showStatusBarItem: Bool {
        get { return defaults.bool(forKey: "showStatusBarItem") }
        set { defaults.set(newValue, forKey: "showStatusBarItem") }
    }

    static var shallowSearch: Bool {
        get { return defaults.bool(forKey: "shallowSearch") }
        set { defaults.set(newValue, forKey: "shallowSearch") }
    }

    static var appendLanguageCode: Bool {
        get { return defaults.bool(forKey: "appendLanguageCode") }
        set { defaults.set(newValue, forKey: "appendLanguageCode") }
    }

    static var mergeAdjacentWhitespaces: Bool {
        get { return defaults.bool(forKey: "mergeAdjacentWhitespaces") }
        set { defaults.set(newValue, forKey: "mergeAdjacentWhitespaces") }
    }

    static var skipAlreadyDownloadedLanguages: Bool {
        get { return defaults.bool(forKey: "skipAlreadyDownloadedLanguages") }
        set { defaults.set(newValue, forKey: "skipAlreadyDownloadedLanguages") }
    }

    static var convertSubtitles: Bool {
        get { return defaults.bool(forKey: "convertSubtitles") }
        set { defaults.set(newValue, forKey: "convertSubtitles") }
    }

    static var changeEncoding: Bool {
        get { return defaults.bool(forKey: "changeEncoding") }
        set { defaults.set(newValue, forKey: "changeEncoding") }
    }

    static var postNotifications: Bool {
        get { return defaults.bool(forKey: "postNotifications") }
        set { defaults.set(newValue, forKey: "postNotifications") }
    }

    static var closeApplicationWhenFinished: Bool {
        get { return defaults.bool(forKey: "closeApplicationWhenFinished") }
        set { defaults.set(newValue, forKey: "closeApplicationWhenFinished") }
    }

    static var showDownloadSummary: Bool {
        get { return defaults.bool(forKey: "showDownloadSummary") }
        set { defaults.set(newValue, forKey: "showDownloadSummary") }
    }

    static var tryToDetermineFrameRate: Bool {
        get { return defaults.bool(forKey: "tryToDetermineFrameRate") }
        set { defaults.set(newValue, forKey: "tryToDetermineFrameRate") }
    }

    // MARK: - Number Values

    static var backupFrameRate: Double {
        get { return defaults.double(forKey: "backupFrameRate") }
        set { defaults.set(newValue, forKey: "backupFrameRate") }
    }

    // MARK: - Enum Values

    static var expectedSubtitleFormat: SupportedSubtitleFormat {
        get {
            let stringValue = defaults.string(forKey: "expectedSubtitleFormat") ?? ""
            return SupportedSubtitleFormat(rawValue: stringValue) ?? .subRip
        }

        set { defaults.set(newValue.rawValue, forKey: "expectedSubtitleFormat") }
    }

    static var expectedEncoding: String.Encoding {
        get {
            let integerValue = defaults.integer(forKey: "expectedEncoding")
            return String.Encoding(rawValue: UInt(integerValue))
        }

        set { defaults.set(newValue.rawValue, forKey: "expectedEncoding") }
    }

    static var nameConflictAction: NameMatcher.NameConflictAction {
        get {
            let stringValue = defaults.string(forKey: "nameConflictAction") ?? ""
            return NameMatcher.NameConflictAction(rawValue: stringValue) ?? .override
        }

        set { defaults.set(newValue.rawValue, forKey: "nameConflictAction") }
    }

    static var downloadLimit: SubtitleDownloader.DownloadLimit {
        get {
            let stringValue = defaults.string(forKey: "downloadLimit") ?? ""
            return SubtitleDownloader.DownloadLimit(rawValue: stringValue) ?? .firstPerLanguage
        }

        set { defaults.set(newValue.rawValue, forKey: "downloadLimit") }
    }

    static var languages: [Language] {
        get {
            guard let strings = defaults.stringArray(forKey: "languages") else {
                return []
            }

            return strings.map { Language(isoCode: $0) }
        }

        set { defaults.set(newValue.map { $0.isoCode }, forKey: "languages") }
    }

    static var providers: [SubtitleProvider] {
        get {
            guard let strings = defaults.stringArray(forKey: "providers") else {
                return []
            }

            return SupportedSubtitleProvider.allValues
                .map { $0.instance }
                .filter { strings.contains($0.name) }
        }

        set { defaults.set(newValue.map { $0.name }, forKey: "providers") }
    }
}
