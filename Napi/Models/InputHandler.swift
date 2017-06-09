//
//  Created by Mateusz Karwat on 14/05/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import AppKit
import Foundation

/// A set of utility methods to handle inputs 
/// passed to the application in various ways.
struct InputHandler {

    // MARK: Command Line

    /// Takes a `URL` passed from Command Line and scans it to find all videos.
    /// Detected videos are passed to `NapiEngine` and then download is started.
    static func parseLaunchArguments() {
        if let launchURL = InputHandler.urlFromLaunchArgument {
            applicationDidReceiveURLs([launchURL])
        } else {
            if Preferences[.runInBackground] && Preferences[.closeApplicationWhenFinished] {
                NSApp.terminate(nil)
            }
        }
    }

    // MARK: User Interface

    /// Takes all `URL`s droped on the application's icon
    /// or passed using "Open with..." menu option.
    static func applicationDidReceiveURLs(_ urls: [URL]) {
        let videoURLs = DirectoryScanner.videoFiles(in: urls, shallowSearch: Preferences[.shallowSearch])
        let sortedVideoURLs = videoURLs.sorted  { $0.0.absoluteString < $0.1.absoluteString }

        if Preferences[.runInBackground] {
            applicationDelegate.commandLineFlowController.handleFiles(at: sortedVideoURLs)
        } else {
            applicationDelegate.mainFlowController.handleUnknownFiles(at: sortedVideoURLs)
        }
    }

    // MARK: - Private Methods

    private static var urlFromLaunchArgument: URL? {
        guard let path = UserDefaults.standard.string(forKey: "pathToScan") else {
            return nil
        }

        return URL(fileURLWithPath: path)
    }
}
