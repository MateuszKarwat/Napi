//
//  Created by Mateusz Karwat on 08/03/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

extension UserDefaults {

    /// Tries to add the contents of the `DefaultSettings.plist` to the registration domain.
    ///
    /// - Note: To get rid of current settings, remove .plist file and run `killall -u $USER cfprefsd`.
    func registerDefaultSettings() {
        guard
            let defaultSettingsURL = Bundle.main.url(forResource: "DefaultPreferences", withExtension: "plist"),
            let plistContent = FileManager.default.contents(atPath: defaultSettingsURL.path) else {
                return
        }
        do {
            let plistData = try PropertyListSerialization.propertyList(from: plistContent, options: [], format: nil) as? [String : Any]

            if let plistData = plistData {
                self.register(defaults: plistData)
            }
        } catch {
            return
        }
    }
}
