//
//  Created by Mateusz Karwat on 09/04/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import AppKit

final class DownloadPreferencesViewController: NSViewController {
    @IBOutlet private weak var downloadLimitNoneRadioButton: NSButton!
    @IBOutlet private weak var downloadLimitFirstMatchRadioButton: NSButton!
    @IBOutlet private weak var downloadLimitFirstMatchPerLanguageRadioButton: NSButton!

    var downloadLimitRadioButtonsBinding: [SubtitleDownloader.DownloadLimit: NSButton] {
        return [.none: downloadLimitNoneRadioButton,
                .first: downloadLimitFirstMatchRadioButton,
                .firstPerLanguage: downloadLimitFirstMatchPerLanguageRadioButton]
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDownloadLimitRadioButtons()
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some(Segue.Providers.storyboardIdentifier):
            if let checkboxTableViewController = segue.destinationController as? CheckboxTableViewController {
                setupCheckboxTableViewControllerForProvidersSegue(checkboxTableViewController)
            }
        case .some(Segue.Languages.storyboardIdentifier):
            if let checkboxTableViewController = segue.destinationController as? CheckboxTableViewController {
                setupCheckboxTableViewControllerForLanguagesSegue(checkboxTableViewController)
            }
        default:
            break
        }
    }


    // MARK: - Download Limit

    private func setupDownloadLimitRadioButtons() {
        if let enabledRadioButton = downloadLimitRadioButtonsBinding[Preferences[.downloadLimit]] {
            enabledRadioButton.state = 1
        }
    }

    @IBAction private func downloadLimitRadioButtonDidChange(_ sender: NSButton) {
        downloadLimitRadioButtonsBinding.forEach { downloadLimit, radioButton in
            if radioButton === sender {
                Preferences[.downloadLimit] = downloadLimit
                return
            }
        }
    }

    // MARK: - Providers

    private func setupCheckboxTableViewControllerForProvidersSegue(_ viewController: CheckboxTableViewController) {
        let availableProviders = SupportedSubtitleProvider.allValues.map { $0.instance }
        let selectedProviders = Preferences[.providers]
        let selectedProvidersNames = selectedProviders.map { $0.name }
        let unselectedProviders = availableProviders.filter { !selectedProvidersNames.contains($0.name) }
        let orderedProviders = selectedProviders + unselectedProviders

        viewController.showCellImage = true

        viewController.contentElements = orderedProviders.map {
            CheckboxTableViewController.ContentElement(isSelected: selectedProvidersNames.contains($0.name),
                                                       image: NSImage(named: $0.name),
                                                       value: $0)
        }

        viewController.cancelAction = {
            self.dismissViewController(viewController)
        }

        viewController.applyAction = {
            Preferences[.providers] = viewController.selectedContentObjects.map { $0.value as! SubtitleProvider }
            self.dismissViewController(viewController)
        }
    }

    // MARK: - Languages

    private func setupCheckboxTableViewControllerForLanguagesSegue(_ viewController: CheckboxTableViewController) {
        let selectedLanguages = Preferences[.languages]

        let availableLanguages = Locale.isoLanguageCodes
            .filter { !Constants.incorrectLanguages.contains($0) }
            .map { Language(isoCode: $0) }

        let unselectedLanguages = availableLanguages
            .filter { !selectedLanguages.contains($0) }
            .sorted(by: { $0.description < $1.description })

        let orderedLanguages = selectedLanguages + unselectedLanguages

        viewController.contentElements = orderedLanguages.map {
            CheckboxTableViewController.ContentElement(isSelected: selectedLanguages.contains($0),
                                                       image: nil,
                                                       value: $0)
        }

        viewController.cancelAction = {
            self.dismissViewController(viewController)
        }

        viewController.applyAction = {
            Preferences[.languages] = viewController.selectedContentObjects.map { $0.value as! Language }
            self.dismissViewController(viewController)
        }
    }
}

// MARK: - Storyboard Identifiers

extension DownloadPreferencesViewController {
    enum Segue: StoryboardIdentifiable {
        case Providers
        case Languages
    }
}

// MARK: - Constants

extension DownloadPreferencesViewController {
    fileprivate struct Constants {
        static let incorrectLanguages = ["mul", "und", "zxx", "mdh", "mis", "swc"]
    }
}
