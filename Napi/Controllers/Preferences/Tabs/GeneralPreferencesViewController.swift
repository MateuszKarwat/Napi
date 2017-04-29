//
//  Created by Mateusz Karwat on 09/04/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import AppKit

final class GeneralPreferencesViewController: NSViewController {
    
    @IBAction func showDockIconDidChange(_ sender: NSButton) {
        updateApplicationVisibility()
    }

    @IBAction func showStatusBarIconDidChange(_ sender: NSButton) {
        updateApplicationVisibility()
    }

    private func updateApplicationVisibility() {
        let delegate = NSApp.delegate as! AppDelegate
        delegate.setupApplicationActivationPolicy()
        delegate.showApplicationInterface()
    }
}
