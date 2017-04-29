//
//  Created by Mateusz Karwat on 15/12/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Represents a language based on ISO-639 code representation of names of languages.
struct Language {

    /// A correct ISO-639-1 or ISO-639-2 code representation.
    ///
    /// - SeeAlso: [Table of available codes](http://www.loc.gov/standards/iso639-2/php/English_list.php)
    var isoCode: String

    /// Returns full name of language in locale which directly comes from `isoCode`.
    var name: String? {
        return (Locale(identifier: isoCode) as NSLocale).displayName(forKey: .languageCode, value: isoCode)
    }

    /// Returns full name of language in current locale.
    var currentLocaleName: String? {
        return (Locale.current as NSLocale).displayName(forKey: .languageCode, value: isoCode)
    }

    /// Returns ISO-639-2 code if such code exists. Otherwise it returns `isoCode`.
    var isoCodeLong: String {
        guard
            let plistURL = Bundle.main.url(forResource: "ISO-639-NameMapping", withExtension: "plist"),
            let isoCodes = NSDictionary(contentsOf: plistURL),
            let isoCodeLong = isoCodes[isoCode] as? String
        else {
            return isoCode
        }

        return isoCodeLong
    }
}

extension Language: Equatable {
    static func ==(lhs: Language, rhs: Language) -> Bool {
        return lhs.isoCode == rhs.isoCode
    }
}

extension Language: CustomStringConvertible {
    var description: String {
        return currentLocaleName ?? isoCode
    }
}
