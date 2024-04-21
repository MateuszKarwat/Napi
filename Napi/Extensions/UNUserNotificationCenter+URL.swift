//
//  Created by Mateusz Karwat on 13/03/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import UserNotifications

extension UNUserNotificationCenter {
    func postNotification(forFileAt url: URL) {
        let content = UNMutableNotificationContent()
        content.title = "Napi"
        content.subtitle = "Subtitles downloaded"
        content.body = url.lastPathComponentWithoutExtension
        content.sound = .default
        content.userInfo = ["url": url.absoluteString]

        let request = UNNotificationRequest(
            identifier: url.absoluteString,
            content: content,
            trigger: nil
        )

        add(request)
    }
}
