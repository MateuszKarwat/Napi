//
//  MenuItemFactory.swift
//  Napi
//
//  Created by Mateusz Karwat on 28/09/2018.
//  Copyright © 2018 Mateusz Karwat. All rights reserved.
//

import AppKit

// TODO: Localize titles

extension NSMenuItem {
    static func downloadSubtitles(target: AnyObject, action: Selector) -> NSMenuItem {
        let menu = NSMenu()

        for subtitleProvider in SupportedSubtitleProvider.allValues {
            let providerMenuItem = NSMenuItem(title: subtitleProvider.instance.name,
                                              action: action,
                                              keyEquivalent: "")
            providerMenuItem.target = target
            providerMenuItem.representedObject = subtitleProvider
            menu.addItem(providerMenuItem)
        }

        let menuItem = NSMenuItem(title: "Download Subtitles",
                                  action: nil,
                                  keyEquivalent: "")
        menuItem.submenu = menu
        return menuItem

    }

    static func showApplication(target: AnyObject, action: Selector) -> NSMenuItem {
        let menuItem = NSMenuItem(title: "Show Napi",
                                  action: action,
                                  keyEquivalent: "")
        menuItem.target = target
        return menuItem
    }

    static func quitApplication() -> NSMenuItem {
        return NSMenuItem(title: "Quit Napi",
                          action: #selector(NSApplication.terminate(_:)),
                          keyEquivalent: "q")
    }
}
