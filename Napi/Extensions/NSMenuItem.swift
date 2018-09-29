//
//  MenuItemFactory.swift
//  Napi
//
//  Created by Mateusz Karwat on 28/09/2018.
//  Copyright © 2018 Mateusz Karwat. All rights reserved.
//

import AppKit

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

        let menuItem = NSMenuItem(title: "StatusBar_Download_Subtitles".localized,
                                  action: nil,
                                  keyEquivalent: "")
        menuItem.submenu = menu
        return menuItem

    }

    static func showApplication(target: AnyObject, action: Selector) -> NSMenuItem {
        let menuItem = NSMenuItem(title: "StatusBar_Show_Napi".localized,
                                  action: action,
                                  keyEquivalent: "")
        menuItem.target = target
        return menuItem
    }

    static func quitApplication() -> NSMenuItem {
        return NSMenuItem(title: "StatusBar_Quit_Napi".localized,
                          action: #selector(NSApplication.terminate(_:)),
                          keyEquivalent: "q")
    }
}
