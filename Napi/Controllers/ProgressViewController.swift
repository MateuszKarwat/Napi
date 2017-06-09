//
//  Created by Mateusz Karwat on 14/05/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import AppKit

final class ProgressViewController: NSViewController {
    @IBOutlet private weak var indicator: NSProgressIndicator!

    dynamic var viewModel: ProgressViewModel?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        indicator.startAnimation(nil)
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        viewModel?.viewDidAppear()
    }

    // MARK: - Actions

    @IBAction func cancelButtonClicked(_ sender: NSButton) {
        viewModel?.cancelButtonClicked()
    }
}
