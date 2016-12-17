//
//  Created by Mateusz Karwat on 17/12/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

extension Date {

    /// Returns a current date timestamp in ISO-8601 format without colons
    /// and with extra miliseconds part.
    /// The overall format is `yyyy-MM-dd'T'HHmmssSSS'Z'`.
    var timestamp: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HHmmssSSS'Z'"
        return dateFormatter.string(from: self)
    }
}
