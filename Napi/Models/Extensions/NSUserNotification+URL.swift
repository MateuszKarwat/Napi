//
//  Created by Mateusz Karwat on 13/03/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

extension NSUserNotificationCenter {

    /// Creates and immediately delivers notification.
    ///
    /// - Parameter url: A `URL` which will be stored in `userInfo` as a `String`.
    ///                  `url` will be stored under `"url"` key.
    func postNotification(forFileAt url: URL) {
        let notification = NSUserNotification()
        notification.title = "Napi"
        notification.subtitle = "Subtitles downloaded"
        notification.informativeText = url.lastPathComponentWithoutExtension
        notification.deliveryDate = Date(timeIntervalSinceNow: 0)
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.hasActionButton = true
        notification.userInfo = ["url": url.absoluteString]
        
        self.deliver(notification)
    }
}
