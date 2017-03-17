//
//  Created by Mateusz Karwat on 03/08/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Represents a subtitle format which is supported,
/// that is, `SubtitleFormat` protocol is implemented.
enum SupportedSubtitleFormat: String {
    case mpl2
    case microDVD
    case subRip
    case tmplayer

    /// Returns an `Array` with all supported subtitle formats.
    static var allValues: [SupportedSubtitleFormat] {
        return [.mpl2, .microDVD, .subRip, .tmplayer]
    }

    /// Returns a `Set` with file extensions of supported formats.
    static var allFileExtensions: Set<String> {
        return Set(self.allValues.map { $0.type.fileExtension })
    }

    /// Returns a type which implements specific subtitle format.
    var type: SubtitleFormat.Type {
        switch self {
        case .mpl2:
            return MPL2SubtitleFormat.self
        case .microDVD:
            return MicroDVDSubtitleFormat.self
        case .subRip:
            return SubRipSubtitleFormat.self
        case .tmplayer:
            return TMPlayerSubtitleFormat.self
        }
    }
}
