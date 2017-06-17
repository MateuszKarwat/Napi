//
//  Created by Mateusz Karwat on 12/03/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Cocoa
import Foundation

final class StatusBarItemController {

    private let statusItem = NSStatusBar.system().statusItem(withLength: -2)

    var isStatusItemVisible = false {
        didSet {
            statusItem.isVisible = isStatusItemVisible
        }
    }

    // MARK: - Lifecycle

    init() {
        setupStatusItem()
    }

    // MARK: - Private Functions

    private func setupStatusItem() {
        statusItem.isVisible = false
        statusItem.image = #imageLiteral(resourceName: "StatusBarIcon")
        statusItem.target = self
        statusItem.action = #selector(statusItemClicked(_:))
    }

    @objc private func statusItemClicked(_ sender: AnyObject) {
        let delegate = NSApp.delegate as! AppDelegate
        _ = delegate.applicationShouldHandleReopen(NSApp, hasVisibleWindows: false)
    }
}
