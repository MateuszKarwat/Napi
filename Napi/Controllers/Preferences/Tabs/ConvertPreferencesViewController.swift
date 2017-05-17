//
//  Created by Mateusz Karwat on 09/04/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import AppKit

final class ConvertPreferencesViewController: NSViewController {

    // MARK: - Frame Rate

    @IBOutlet private weak var frameRateComboBox: NSComboBox! {
        didSet {
            frameRateComboBox.stringValue = String(Preferences[.backupFrameRate])
        }
    }

    @IBAction private func frameRateComboBoxDidChange(_ sender: NSComboBox) {
        if let newFrameRate = Double(sender.stringValue) {
            Preferences[.backupFrameRate] = newFrameRate
        } else {
            sender.stringValue = ""
        }
    }

    // MARK: - Subtitle Format

    @IBOutlet private var subtitleFormatsArrayController: NSArrayController! {
        didSet {
            let availableSubtitleFormats = SupportedSubtitleFormat.allValues
            subtitleFormatsArrayController.add(contentsOf: availableSubtitleFormats)

            if let expectedSubtitleFormat = Preferences[.expectedSubtitleFormat],
                let selectionIndex = availableSubtitleFormats.index(of: expectedSubtitleFormat) {
                subtitleFormatsArrayController.setSelectionIndex(selectionIndex)
            }
        }
    }

    @IBAction private func subtitleFormatPopUpButtonDidChange(_ sender: NSPopUpButton) {
        if let newSubtitleFormat = subtitleFormatsArrayController.selectedObjects.first as? SupportedSubtitleFormat {
            Preferences[.expectedSubtitleFormat] = newSubtitleFormat
        }
    }

    // MARK: - Encoding

    @IBOutlet private var encodingsArrayController: NSArrayController! {
        didSet {
            let availableEncodings = String.availableStringEncodings
            let selectionIndex = availableEncodings.index(of: Preferences[.expectedEncoding]) ?? 0

            encodingsArrayController.add(contentsOf: availableEncodings)
            encodingsArrayController.setSelectionIndex(selectionIndex)
        }
    }

    @IBAction private func encodingPopUpButtonDidChange(_ sender: NSPopUpButton) {
        if let newEncoding = encodingsArrayController.selectedObjects.first as? String.Encoding {
            Preferences[.expectedEncoding] = newEncoding
        }
    }
}
