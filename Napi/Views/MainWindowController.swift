//
//  Created by Mateusz Karwat on 12/03/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Cocoa
import Foundation

final class MainWindowController: NSWindowController {
    private struct Constants {
        static let autosaveName = "MainWindow"
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        shouldCascadeWindows = false
        window?.setFrameAutosaveName(Constants.autosaveName)
    }
}
