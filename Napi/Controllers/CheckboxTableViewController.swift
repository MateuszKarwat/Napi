//
//  Created by Mateusz Karwat on 12/04/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import AppKit

final class CheckboxTableViewController: NSViewController {
    @IBOutlet fileprivate weak var tableView: NSTableView!
    @IBOutlet fileprivate weak var cancelButton: NSButton!
    @IBOutlet fileprivate weak var applyButton: NSButton!
    @IBOutlet fileprivate weak var descriptionTextField: NSTextField!
    @IBOutlet fileprivate weak var tableViewWidthConstraint: NSLayoutConstraint!

    // MARK: - Properties

    var viewModel: CheckboxTableViewModel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTextField.stringValue = viewModel.description

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(forDraggedTypes: [Constants.dragTypeUTI])

        updateTableViewWidthConstraint()
    }

    // MARK: - IBActions

    @IBAction func checkboxButtonDidChange(_ sender: NSButton) {
        viewModel.selectionDidChange(at: tableView.row(for: sender))

        tableView.reloadData()
    }
    
    @IBAction func cancelButtonClicked(_ sender: NSButton) {
        viewModel.cancelButtonClicked()
        dismiss(nil)
    }

    @IBAction func applyButtonClicked(_ sender: NSButton) {
        viewModel.applyButtonClicked()
        dismiss(nil)
    }

    // MARK: - Private Properties

    /// Counts a fitting size of content column.
    private var contentColumnWidth: CGFloat {
        var calculatedWidth: CGFloat = 0.0

        for row in 0 ..< min(viewModel.numberOfRows, 20) {
            guard
                let cellView = tableView.view(atColumn: tableView.tableColumns.count - 1,
                                              row: row,
                                              makeIfNecessary: true) as? NSTableCellView,
                let textFieldWidth = cellView.textField?.fittingSize.width
            else {
                continue
            }

            let remainingSubviewsCombinedWidth = cellView.subviews
                .filter { $0 as? NSTextField == nil }
                .map { $0.frame.size.width }
                .reduce(0.0, +)

            calculatedWidth = max(calculatedWidth, textFieldWidth + remainingSubviewsCombinedWidth)
        }

        return calculatedWidth
    }

    // MARK: - Private Functions

    // MARK: Sizing

    /// Updates a width of table view based on calculated fitting size of content column
    /// and hard-coded extra spacing.
    ///
    /// - Note: It would be nice to remove hard-coded values and calculate it dynamically.
    private func updateTableViewWidthConstraint() {
        let extraSpaceForOtherColumns: CGFloat = 17 * 3.0
        let calculatedTableViewWidthContant = contentColumnWidth + extraSpaceForOtherColumns

        tableViewWidthConstraint.constant = max(tableViewWidthConstraint.constant, calculatedTableViewWidthContant)
    }
}

// MARK: - NSTableViewDataSource

extension CheckboxTableViewController: NSTableViewDataSource {

    // MARK: Data

    func numberOfRows(in tableView: NSTableView) -> Int {
        return viewModel.numberOfRows
    }

    // MARK: Drag and Drop

    func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
        let item = NSPasteboardItem()
        item.setString(String(row), forType: Constants.dragTypeUTI)
        return item
    }

    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
        if dropOperation == .above {
            return .move
        }

        return []
    }

    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
        var oldIndexes = [Int]()

        info.enumerateDraggingItems(options: [], for: tableView, classes: [NSPasteboardItem.self], searchOptions: [:]) {
            if let pasteboardString = ($0.0.item as! NSPasteboardItem).string(forType: Constants.dragTypeUTI),
               let index = Int(pasteboardString) {
                   oldIndexes.append(index)
            }
        }

        let indexesToSelect = viewModel.didMoveElements(at: oldIndexes, to: row)

        tableView.reloadData()
        tableView.selectRowIndexes(IndexSet(indexesToSelect), byExtendingSelection: false)

        return true
    }
}

// MARK: - NSTableViewDelegate

extension CheckboxTableViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard
            let elementToDisplay = viewModel.element(at: row),
            let columnIdentifier = tableColumn?.identifier
        else {
            return nil
        }

        switch columnIdentifier {
        case Column.Content.storyboardIdentifier:
            return contentColumnCellView(with: elementToDisplay)
        case Column.Checkbox.storyboardIdentifier:
            return checkboxColumnCellView(with: elementToDisplay)
        default:
            return nil
        }
    }

    private func contentColumnCellView(with element: CheckboxTableViewModel.Element) -> NSView {
        let cellView: NSTableCellView

        if viewModel.showCellImage {
            cellView = tableView.make(withIdentifier: Cell.ImageAndText.storyboardIdentifier, owner: nil) as! NSTableCellView
            cellView.imageView?.image = element.image
        } else {
            cellView = tableView.make(withIdentifier: Cell.Text.storyboardIdentifier, owner: nil) as! NSTableCellView
        }

        cellView.textField?.stringValue = element.description

        return cellView
    }

    private func checkboxColumnCellView(with element: CheckboxTableViewModel.Element) -> NSView {
        let cellView = tableView.make(withIdentifier: Cell.Checkbox.storyboardIdentifier, owner: nil) as! NSButton
        cellView.state = element.isSelected ? 1 : 0
        return cellView
    }
}

// MARK: - Storyboard Identifiers

extension CheckboxTableViewController {
    enum Column: StoryboardIdentifiable {
        case Checkbox
        case Content
    }

    enum Cell: StoryboardIdentifiable {
        case Checkbox
        case Text
        case ImageAndText
    }
}

// MARK: - Constants

extension CheckboxTableViewController {
    fileprivate struct Constants {
        static let dragTypeUTI = "private.tableViewRow"
    }
}
