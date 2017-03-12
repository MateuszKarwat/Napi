//
//  Created by Mateusz Karwat on 12/03/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Cocoa
import Foundation

final class StatusBarItemController {

    private let statusItem = NSStatusBar.system().statusItem(withLength: -2)

    // MARK: - Lifecycle

    init() {
        setupStatusItem()
    }

    // MARK: - Public Functions

    /// Shows status item.
    func showStatusItem() {
        statusItem.isVisible = true
    }

    /// Hides status item.
    func hideStatusItem() {
        statusItem.isVisible = false
    }

    // MARK: - Private Functions

    private func setupStatusItem() {
        statusItem.isVisible = false
        statusItem.image = #imageLiteral(resourceName: "StatusBarButtonImage")
        statusItem.target = self
        statusItem.action = #selector(statusItemClicked(_:))
    }

    @objc private func statusItemClicked(_ sender: AnyObject) {
        let delegate = NSApp.delegate as! AppDelegate
        _ = delegate.applicationShouldHandleReopen(NSApp, hasVisibleWindows: false)
    }
}
