//
//  Created by Mateusz Karwat on 12/03/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Represents a subtitle provider which is supported,
/// that is, `SubtitleProvider` protocol is implemented.
enum SupportedSubtitleProvider {
    case napisy24
    case openSubtitles
    case napiProjekt

    /// Returns an aray with all supported subtitle providers.
    static var allValues: [SupportedSubtitleProvider] {
        return [.napisy24, .openSubtitles, .napiProjekt]
    }

    /// Returns a new instance of corresponding
    /// with specific subtitle provider.
    var instance: SubtitleProvider {
        switch self {
        case .napisy24:
            return Napisy24()
        case .openSubtitles:
            return OpenSubtitles()
        case .napiProjekt:
            return NapiProjekt()
        }
    }
}

extension SupportedSubtitleProvider {

    /// Takes all supported subtitle providers if there is one with
    /// a specified name:
    ///
    /// - Parameter name: Name of requested `SubtitleProvider`.
    ///
    /// - Returns: A `SubtitleProvider` which name equals `name`.
    ///            If there is no `SubtitleProvider` with such name, returns `nil`.
    static func provider(withName name: String) -> SubtitleProvider? {
        for provider in SupportedSubtitleProvider.allValues.map({ $0.instance }) {
            if provider.name == name {
                return provider
            }
        }

        return nil
    }
}
