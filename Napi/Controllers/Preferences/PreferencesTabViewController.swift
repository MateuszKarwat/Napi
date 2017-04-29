//
//  Created by Mateusz Karwat on 09/04/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import AppKit

final class PreferencesTabViewController: NSTabViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tabView.delegate = self
    }

    override func viewWillAppear() {
        super.viewWillAppear()

        if let tabViewItem = tabView.selectedTabViewItem {
            resizeWindowToFit(tabViewItem: tabViewItem)
            tabViewItem.view?.window?.center()
        }
    }

    // MARK: - NSTabViewDelegate

    override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        super.tabView(tabView, didSelect: tabViewItem)

        if let tabViewItem = tabViewItem {
            view.window?.title = tabViewItem.label
            resizeWindowToFit(tabViewItem: tabViewItem)
        }
    }

    // MARK: - Private methods

    /// Resizes the window so that it fits the content of the tab.
    private func resizeWindowToFit(tabViewItem: NSTabViewItem) {
        guard
            let stackViewSize = tabViewItem.view?.subviews.first?.frame,
            let window = view.window
        else {
            return
        }

        tabView.isHidden = true

        let widthWithMargins = stackViewSize.width + Constants.leftMargin + Constants.rightMargin
        let heightWithMargins = stackViewSize.height + Constants.topMargin + Constants.bottomMargin

        let contentRect = NSRect(x: 0, y: 0, width: widthWithMargins, height: heightWithMargins)
        let contentFrame = window.frameRect(forContentRect: contentRect)
        let toolbarHeight = window.frame.size.height - contentFrame.size.height
        let newOrigin = NSPoint(x: window.frame.origin.x, y: window.frame.origin.y + toolbarHeight)
        let newFrame = NSRect(origin: newOrigin, size: contentFrame.size)	
        window.setFrame(newFrame, display: false, animate: true)

        tabView.isHidden = false
    }
}

extension PreferencesTabViewController {
    fileprivate struct Constants {
        static let topMargin: CGFloat = 16.0
        static let bottomMargin: CGFloat = 16.0
        static let leftMargin: CGFloat = 32.0
        static let rightMargin: CGFloat = 32.0
    }
}
