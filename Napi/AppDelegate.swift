//
//  Created by Mateusz Karwat on 05/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import AppKit
import SwiftyBeaver

let log = SwiftyBeaver.self

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: - Controllers

    lazy var statusBarItemController: StatusBarItemController = {
        return StatusBarItemController()
    }()

    lazy var mainWindowController: MainWindowController = {
        return Storyboard.Main.instantiate(MainWindowController.self)
    }()

    // MARK: - Lifecycle

    func applicationDidFinishLaunching(_ notification: Notification) {
        UserDefaults.standard.registerDefaultSettings()
        setupSwiftyBeaver()
        setupApplicationActivationPolicy()
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        showApplicationInterface()
        return true
    }

    // MARK: - Appearance

    /// Based on current settings sets application policy.
    func setupApplicationActivationPolicy() {
        if !Preferences[.runInBackground] {
            NSApp.setActivationPolicy( Preferences[.showDockIcon] ? .regular : .accessory)

            statusBarItemController.isStatusItemVisible = Preferences[.showStatusBarItem]

            showApplicationInterface()
        }
    }

    /// Brings application to front and shows main window if none window is opened.
    func showApplicationInterface() {
        if NSApp.mainWindow == nil && NSApp.keyWindow == nil {
            mainWindowController.showWindow(self)
        }

        NSApp.activate(ignoringOtherApps: true)
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

    // MARK: - SwiftyBeaver

    private func setupSwiftyBeaver() {
        let file = FileDestination()
        let console = ConsoleDestination()

        if let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
            let bundleName = Bundle.main.bundleIdentifier {
            let logURL = cachesURL
                .appendingPathComponent(bundleName, isDirectory: true)
                .appendingPathComponent("Napi.log")
            file.logFileURL = logURL

            if let fileInformation = FileInformation(url: logURL), fileInformation.size > 10_000_000 {
                _ = file.deleteLogFile()
            }
        }

        file.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $C$L$c\t$N - $M"
        console.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $C$L$c \t$N - $M"

        log.addDestination(file)
        log.addDestination(console)
    }
}
