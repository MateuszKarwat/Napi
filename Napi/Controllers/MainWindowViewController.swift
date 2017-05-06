//
//  Created by Mateusz Karwat on 29/04/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import AppKit

final class MainWindowViewController: NSViewController {
    @IBOutlet var draggingDestinationView: DraggingDestinationView! {
        didSet {
            draggingDestinationView.delegate = self
        }
    }
}

// MARK: - DraggingDestinationViewDelegate

extension MainWindowViewController: DraggingDestinationViewDelegate {
    func draggingDestinationView(_ view: DraggingDestinationView, didReceiveURLs urls: [URL]) {
        guard view.window?.attachedSheet == nil else {
            return
        }

        let videoFiles = DirectoryScanner.videoFiles(in: urls, shallowSearch: Preferences[.shallowSearch])
        let contentElements = videoFiles.map {
            CheckboxTableViewController.ContentElement(isSelected: true,
                                                       image: FileInformation(url: $0)?.image,
                                                       value: $0)
        }

        let checkboxTableViewController = Storyboard.Selection.instantiate(CheckboxTableViewController.self)
        checkboxTableViewController.showCellImage = true
        checkboxTableViewController.contentElements = contentElements

        checkboxTableViewController.customDescription = {
            let url = $0.value as! URL
            return FileInformation(url: url)?.name ?? url.description
        }

        checkboxTableViewController.cancelAction = {
            self.dismissViewController(checkboxTableViewController)
        }

        checkboxTableViewController.applyAction = {
            // TODO: Do something with accepted video files.
            self.dismissViewController(checkboxTableViewController)
        }

        presentViewControllerAsSheet(checkboxTableViewController)
    }
}

fileprivate extension FileInformation {

    /// Returns an image of a file.
    var image: NSImage? {
        guard let resourceValues = try? (url as NSURL).resourceValues(forKeys: [URLResourceKey.effectiveIconKey]) else {
            return nil
        }

        return resourceValues[URLResourceKey.effectiveIconKey] as? NSImage
    }
}
