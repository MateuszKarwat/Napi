//
//  Created by Mateusz Karwat on 12/03/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

// TODO: Add comments.
enum SupportedSubtitleProvider {
    case napisy24
    case openSubtitles
    case napiProjekt

    static var allValues: [SupportedSubtitleProvider] {
        return [.napisy24, .openSubtitles, .napiProjekt]
    }

    var type: SubtitleProvider {
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
