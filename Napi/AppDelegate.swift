//
//  Created by Mateusz Karwat on 05/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: - Controllers

    lazy var statusBarItemController: StatusBarItemController = {
        return StatusBarItemController()
    }()

    lazy var mainWindowController: MainWindowController = {
        let mainStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = mainStoryboard.instantiateController(withIdentifier: "MainWindowController") as! MainWindowController
        return windowController
    }()

    // MARK: - Lifecycle

    func applicationDidFinishLaunching(_ notification: Notification) {
        UserDefaults.standard.registerDefaultSettings()

        setupApplicationActivationPolicy()
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        showApplicationInterface()
        return true
    }

    // MARK: - Appearance

    /// Shows Main Window and brings application to front.
    private func showApplicationInterface() {
        mainWindowController.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
    }

    /// Based on current settings sets application policy.
    private func setupApplicationActivationPolicy() {
        if applicationShouldRunInForeground {
            if Preferences.General.showDockIcon {
                NSApp.setActivationPolicy(.regular)
            }

            if Preferences.General.showStatusBarItem {
                statusBarItemController.showStatusItem()
            }

            showApplicationInterface()
        }
    }


    /// Returns `true` if application has been run with run parameter
    /// `runInBackground` set to `true.
    private var applicationShouldRunInForeground: Bool {
        return !UserDefaults.standard.bool(forKey: "runInBackground")
    }

    // MARK: - Handle Files and Directories

    // MARK: Command Line

    /// Takes a `URL` passed from Command Line and scans it to find all videos.
    ///
    /// - Returns: `URL`s to all videos in `-pathToScan` `URL`.
    private func videoURLsInPathFromCommandLine() -> [URL] {
        guard let path = UserDefaults.standard.string(forKey: "pathToScan") else {
            return []
        }

        let url = URL(fileURLWithPath: path)

        return DirectoryScanner.videoFiles(inDirectoryAt: url)
    }

    // MARK: Drag on an icon or use "Open with..."

    private var queuedPaths = [String]()

    /// Takes all `URL`s droped on the application's icon
    /// or passed using "Open with..." menu option.
    func application(_ sender: NSApplication, openFiles filenames: [String]) {
        // I saw cases in which dragging a bunch of files onto the app
        // actually called application:openFiles several times, resulting
        // in more than one window, with the dragged files split amongst them.
        // This is lame. So we queue them up and open them all at once later.
        queuedPaths += filenames
        perform(#selector(processQueuedPaths), with: nil, afterDelay: 0.25)

        NSApp.reply(toOpenOrPrint: .success)
    }

    func processQueuedPaths() {
        guard queuedPaths.isNotEmpty else {
            return
        }

        let urls = queuedPaths.map { URL(fileURLWithPath: $0) }
        let onlyVideos = DirectoryScanner.videoFiles(in: urls)

        // TODO: Do something with videoURLs.
        dump(onlyVideos)

        queuedPaths = []
    }
}
