//
//  Created by Mateusz Karwat on 09/04/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import AppKit

final class MatchPreferencesViewController: NSViewController {
    @IBOutlet private weak var cancelRadioButton: NSButton!
    @IBOutlet private weak var overrideRadioButton: NSButton!
    @IBOutlet private weak var backupNewSubtitlesRadioButton: NSButton!
    @IBOutlet private weak var backupExistingSubtitlesRadioButton: NSButton!

    var radioButtonsBinding: [NameMatcher.NameConflictAction: NSButton] {
        return [.cancel: cancelRadioButton,
                .override: overrideRadioButton,
                .backupSourceItem: backupNewSubtitlesRadioButton,
                .backupDestinationItem: backupExistingSubtitlesRadioButton]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRadioButtons()
    }

    private func setupRadioButtons() {
        if let enabledRadioButton = radioButtonsBinding[Preferences[.nameConflictAction]] {
            enabledRadioButton.state = 1
        }
    }

    @IBAction func nameConflictActionRadioButtonDidChange(_ sender: NSButton) {
        radioButtonsBinding.forEach { nameConflictAction, radioButton in
            if radioButton === sender {
                Preferences[.nameConflictAction] = nameConflictAction
                return
            }
        }
    }
}
