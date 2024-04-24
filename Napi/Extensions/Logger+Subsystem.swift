//
//  Created by Mateusz Karwat on 19/04/2024.
//  Copyright © 2024 Mateusz Karwat. All rights reserved.
//

import OSLog

extension Logger {
    init(category: String) {
        self.init(
            subsystem: Bundle.main.bundleIdentifier!,
            category: category
        )
    }
}
