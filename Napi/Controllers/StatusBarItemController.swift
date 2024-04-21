//
//  Created by Mateusz Karwat on 12/03/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Cocoa
import Foundation

protocol StatusBarItemControllerDelegate: AnyObject {
    func statusBarItemController(_ sbic: StatusBarItemController,
                                 didSelectDownloadSubtitlesUsing provider: SupportedSubtitleProvider)
}

final class StatusBarItemController {

    private let statusItem = NSStatusBar.system.statusItem(withLength: -2)

    weak var delegate: StatusBarItemControllerDelegate?

    var isStatusItemVisible = false {
        didSet {
            statusItem.isVisible = isStatusItemVisible
        }
    }

    // MARK: - Lifecycle

    init() {
        setupStatusItem()
        createMainMenu()
    }

    // MARK: - Private Functions

    private func setupStatusItem() {
        statusItem.isVisible = false
        statusItem.button?.image = #imageLiteral(resourceName: "StatusBarIcon")
    }

    private func createMainMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem.downloadSubtitles(target: self, action: #selector(subtitleProviderMenuItemClicked(_:))))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem.showApplication(target: self, action: #selector(showApplicationMenuItemClicked)))
        menu.addItem(NSMenuItem.quitApplication())

        statusItem.menu = menu
    }

    @objc
    private func subtitleProviderMenuItemClicked(_ sender: AnyObject) {
        guard let menuItem = sender as? NSMenuItem,
              let subtitleProvider = menuItem.representedObject as? SupportedSubtitleProvider else {
            return
        }

        delegate?.statusBarItemController(self, didSelectDownloadSubtitlesUsing: subtitleProvider)
    }

    @objc
    private func showApplicationMenuItemClicked() {
        let delegate = NSApp.delegate as! AppDelegate
        _ = delegate.applicationShouldHandleReopen(NSApp, hasVisibleWindows: false)
    }
}
