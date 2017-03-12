//
//  Created by Mateusz Karwat on 12/03/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

fileprivate let defaults = UserDefaults.standard

/// Utility struct to simplify access to all preferences.
struct Preferences {
    struct General {
        static var showDockIcon: Bool {
            get { return defaults.value(forKeyPath: "General.showDockIcon") as? Bool ?? false }
            set { defaults.setValue(newValue, forKeyPath: "General.showDockIcon") }
        }

        static var showStatusBarItem: Bool {
            get { return defaults.value(forKeyPath: "General.showStatusBarItem") as? Bool ?? false }
            set { defaults.setValue(newValue, forKeyPath: "General.showStatusBarItem") }
        }
    }
}
