//
//  Created by Mateusz Karwat on 05/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import AppKit
import UserNotifications

let applicationDelegate = NSApp.delegate as! AppDelegate

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    lazy var mainFlowController = MainFlowController()
    lazy var commandLineFlowController = CommandLineFlowController()
    lazy var statusBarItemController = StatusBarItemController()

    // MARK: - Lifecycle

    func applicationDidFinishLaunching(_ notification: Notification) {
        UserDefaults.standard.registerDefaultSettings()
        UNUserNotificationCenter.current().delegate = self

        setupApplicationActivationPolicy()

        InputHandler.parseLaunchArguments()
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        mainFlowController.showApplicationInterface()

        return true
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        TemporaryDirectoryManager.default.cleanupTemporaryDirectory()

        return .terminateNow
    }

    // MARK: - Appearance

    /// Sets application policy based on current settings.
    func setupApplicationActivationPolicy() {
        if !Preferences[.runInBackground] {
            NSApp.setActivationPolicy(Preferences[.showDockIcon] ? .regular : .accessory)

            statusBarItemController.isStatusItemVisible = Preferences[.showStatusBarItem]
            statusBarItemController.delegate = mainFlowController

            mainFlowController.showApplicationInterface()
        }
    }

    // MARK: - Handle Files and Directories

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

    @objc func processQueuedPaths() {
        guard queuedPaths.isNotEmpty else {
            return
        }

        let urls = queuedPaths.map { URL(fileURLWithPath: $0) }
        InputHandler.applicationDidReceiveURLs(urls)

        queuedPaths = []
    }

    /// First responder for cmd+o shortcut.
    func openDocument(_ sender: Any?) {
        mainFlowController.presentOpenPanel()
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        guard let absoluteURL = response.notification.request.content.userInfo["url"] as? String,
              let fileURL = URL(string: absoluteURL) else {
            return
        }

        center.removeDeliveredNotifications(withIdentifiers: [absoluteURL])
        NSWorkspace.shared.activateFileViewerSelecting([fileURL])
    }
}
