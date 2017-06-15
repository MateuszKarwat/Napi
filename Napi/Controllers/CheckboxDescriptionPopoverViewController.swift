//
//  Created by Mateusz Karwat on 15/06/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import AppKit

final class CheckboxDescriptionPopoverViewController: NSViewController {
    @IBOutlet private weak var descriptionTextField: NSTextField!

    /// A text visible when popover is displayed.
    var descriptionText: String?

    override func viewDidLoad() {
        descriptionTextField.stringValue = descriptionText ?? ""
    }
}
