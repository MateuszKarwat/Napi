//
//  Created by Mateusz Karwat on 11/06/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

extension String {

    /// Returns a localized string, using the main bundle if one is not specified.
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
