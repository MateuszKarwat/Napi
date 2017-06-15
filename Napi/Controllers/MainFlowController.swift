//
//  Created by Mateusz Karwat on 22/05/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import AppKit

final class MainFlowController {
    fileprivate let mainWindowController = Storyboard.Main.instantiate(MainWindowController.self)

    // MARK: - Public Methods

    /// Brings application to front.
    /// If none window is open, it shows main window.
    func showApplicationInterface() {
        if NSApp.mainWindow == nil && NSApp.keyWindow == nil {
            mainWindowController.showWindow(self)
        }

        NSApp.activate(ignoringOtherApps: true)
    }

    /// Presents a modal window to choose video files to scan.
    func presentOpenPanel() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = true
        panel.allowedFileTypes = ["public.movie"]

        if panel.runModal() == NSFileHandlingPanelOKButton {
            InputHandler.applicationDidReceiveURLs(panel.urls)
        }
    }

    /// Presents selection view to choose video files to scan.
    func handleUnknownFiles(at urls: [URL]) {
        if Preferences[.showDownloadSelection] {
            presentCheckboxTableViewController(with: urls)
        } else {
            handleVideoFiles(at: urls)
        }
    }

    /// Immediately starts a download with progress view as a presenter.
    func handleVideoFiles(at videoURLs: [URL]) {
        if videoURLs.isNotEmpty {
            presentProgressWindow(withVideoURLs: videoURLs)
        }
    }

    // MARK: - Private Methods

    private func presentCheckboxTableViewController(with urls: [URL]) {
        guard
            let mainViewController = mainWindowController.contentViewController as? MainViewController,
            mainWindowController.window?.attachedSheet == nil
        else {
            return
        }

        let elements: [CheckboxTableViewModel.Element] = urls.map {
            let fileInformation = FileInformation(url: $0)
            let image = fileInformation?.image
            let description = fileInformation?.name ?? $0.description

            return .init(value: $0, isSelected: true, image: image, description: description)
        }

        let viewModel = CheckboxTableViewModel(elements: elements)
        viewModel.showCellImage = true
        viewModel.description = "Download_Video_Selection_Description".localized
        viewModel.onApply = { [unowned self] selectedValues in
            self.handleVideoFiles(at: selectedValues.map { $0 as! URL })
        }

        let viewController = Storyboard.Selection.instantiate(CheckboxTableViewController.self)
        viewController.viewModel = viewModel

        mainViewController.presentViewControllerAsSheet(viewController)
    }

    private func presentProgressWindow(withVideoURLs videoURLs: [URL]) {
        guard let mainViewController = mainWindowController.contentViewController as? MainViewController else {
            return
        }

        if let attachedViewController = mainWindowController.window?.attachedSheet?.contentViewController,
           attachedViewController.isKind(of: ProgressViewController.self) {
               return
        }

        let progressViewModel = ProgressViewModel(engine: NapiEngine(), videoURLs: videoURLs)
        progressViewModel.delegate = self

        let progressViewController = Storyboard.Progress.instantiate(ProgressViewController.self)
        progressViewController.viewModel = progressViewModel

        mainViewController.presentViewControllerAsSheet(progressViewController)
    }

    fileprivate func presentCompletionAlert() {
        guard let mainWindow = mainWindowController.window else {
            return
        }

        let downloadCompleteAlert = NSAlert()
        downloadCompleteAlert.alertStyle = .informational
        downloadCompleteAlert.messageText = "Download_Summary_Message".localized
        downloadCompleteAlert.informativeText = "Download_Summary_Informative".localized
        downloadCompleteAlert.beginSheetModal(for: mainWindow) { _ in
            if Preferences[.closeApplicationWhenFinished] {
                NSApp.terminate(nil)
            }
        }
    }
}

extension MainFlowController: ProgressViewModelDelegate {
    func progressViewModelDidFinish(_ progressViewModel: ProgressViewModel) {
        DispatchQueue.main.async {
            if let mainWindow = self.mainWindowController.window,
               let attachedSheet = mainWindow.attachedSheet {
                    mainWindow.endSheet(attachedSheet)
            }

            if Preferences[.showDownloadSummary] {
                self.presentCompletionAlert()
            } else {
                if Preferences[.closeApplicationWhenFinished] {
                    NSApp.terminate(nil)
                }
            }
        }
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
