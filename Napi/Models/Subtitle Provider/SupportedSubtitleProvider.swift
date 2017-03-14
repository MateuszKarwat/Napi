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
