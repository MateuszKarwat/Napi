//
//  Created by Mateusz Karwat on 22/05/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import AppKit
import Foundation

/// Flow Controller responsible for running an app
/// as a command line tool.
final class CommandLineFlowController {
    private var engine: NapiEngine?

    func handleFiles(at urls: [URL]) {
        engine = NapiEngine(subtitleProviders: Preferences[.providers])
        engine?.delegate = self
        engine?.downloadSubtitles(forVideoFilesAt: urls)
    }
}

extension CommandLineFlowController: NapiEngineDelegate {
    func napiEngine(_ napiEngine: NapiEngine, didProvideSubtitlesAt url: URL) {
        if Preferences[.postNotifications] {
            NSUserNotificationCenter.default.postNotification(forFileAt: url)
        }
    }

    func napiEngineDidFinish(_ napiEngine: NapiEngine) {
        if Preferences[.closeApplicationWhenFinished] {
            NSApp.terminate(nil)
        }
    }
}
