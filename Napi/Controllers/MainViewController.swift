//
//  Created by Mateusz Karwat on 29/04/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import AppKit

final class MainViewController: NSViewController {
    @IBOutlet var draggingDestinationView: DraggingDestinationView! {
        didSet {
            draggingDestinationView.delegate = self
        }
    }
}

// MARK: - DraggingDestinationViewDelegate

extension MainViewController: DraggingDestinationViewDelegate {
    func draggingDestinationView(_ view: DraggingDestinationView, didReceiveURLs urls: [URL]) {
        InputHandler.applicationDidReceiveURLs(urls)
    }
}
