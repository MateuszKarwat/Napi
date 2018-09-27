//
//  Created by Mateusz Karwat on 12/03/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Cocoa
import Foundation

final class MainWindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()

        shouldCascadeWindows = false
        window?.setFrameAutosaveName(.autosaveName)
    }
}

// MARK: - Constants

private extension NSWindow.FrameAutosaveName {
    static let autosaveName = "MainWindow"
}
