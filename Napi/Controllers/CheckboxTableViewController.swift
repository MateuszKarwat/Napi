//
//  Created by Mateusz Karwat on 12/04/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import AppKit

final class CheckboxTableViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var applyButton: NSButton!

    // MARK: - Properties

    /// An `Array` of elements which are presented as `tableView`'s content.
    var contentElements = [ContentElement]()

    /// Text displayed above the `tableView` explaining what table view presents.
    var descriptionText: String?

    /// Specifies if the `tableView`'s content comlumn should show an image view.
    var showCellImage = false

    /// A block called when `cancelButton` action is triggered either by click or `ESC` key.
    var cancelAction: (() -> Void)?

    /// A block called when `applyButton` action is triggered either by click or `Return` key.
    var applyAction: (() -> Void)?

    /// Returns a list of selected elements in order they are presented in the `tableView`.
    var selectedContentObjects: [ContentElement] {
        return contentElements.filter { $0.isSelected }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(forDraggedTypes: [Constants.dragTypeUTI])
    }

    // MARK: - IBActions

    @IBAction func checkboxButtonDidChange(_ sender: NSButton) {
        let clickedRow = tableView.row(for: sender)
        let isContentObjectSelected = contentElements[clickedRow].isSelected
        contentElements[clickedRow].isSelected = !isContentObjectSelected

        tableView.reloadData()
    }
    
    @IBAction func cancelButtonClicked(_ sender: NSButton) {
        cancelAction?()
    }

    @IBAction func applyButtonClicked(_ sender: NSButton) {
        applyAction?()
    }
}

// MARK: - NSTableViewDataSource

extension CheckboxTableViewController: NSTableViewDataSource {

    // MARK: Data

    func numberOfRows(in tableView: NSTableView) -> Int {
        return contentElements.count
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

        let draggedObjects = contentElements.removeElements(at: IndexSet(oldIndexes))
        let numberOfIndexesLowerThanRow = oldIndexes.sorted().prefix { $0 < row }.count
        let positionToInsertObjects = max(0, row - numberOfIndexesLowerThanRow)

        let indexesToSelect = draggedObjects.enumerated().map { index, _ in
            index + positionToInsertObjects
        }

        contentElements.insert(contentsOf: draggedObjects, at: positionToInsertObjects)

        tableView.reloadData()
        tableView.selectRowIndexes(IndexSet(indexesToSelect), byExtendingSelection: false)

        return true
    }
}

// MARK: - NSTableViewDelegate

extension CheckboxTableViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if contentElements.count >= row, let columnIdentifier = tableColumn?.identifier {
            let contentObject = contentElements[row]

            switch columnIdentifier {
            case Column.Content.storyboardIdentifier:
                return contentColumnCellView(with: contentObject)
            case Column.Checkbox.storyboardIdentifier:
                return checkboxColumnCellView(with: contentObject)
            default:
                break
            }
        }

        return nil
    }

    private func contentColumnCellView(with contentObject: ContentElement) -> NSView {
        if showCellImage {
            let cellView = tableView.make(withIdentifier: Cell.ImageAndText.storyboardIdentifier, owner: nil) as! NSTableCellView
            cellView.textField?.stringValue = contentObject.value.description
            cellView.imageView?.image = contentObject.image
            return cellView
        } else {
            let cellView = tableView.make(withIdentifier: Cell.Text.storyboardIdentifier, owner: nil) as! NSTableCellView
            cellView.textField?.stringValue = contentObject.value.description
            return cellView
        }
    }

    private func checkboxColumnCellView(with contentObject: ContentElement) -> NSView {
        let cellView = tableView.make(withIdentifier: Cell.Checkbox.storyboardIdentifier, owner: nil) as! NSButton
        cellView.state = contentObject.isSelected ? 1 : 0
        return cellView
    }
}

// MARK: - ContentElement

extension CheckboxTableViewController {
    struct ContentElement {
        var isSelected: Bool
        var image: NSImage?
        var value: CustomStringConvertible
    }
}

extension CheckboxTableViewController.ContentElement {
    init(value: CustomStringConvertible) {
        self.isSelected = false
        self.image = nil
        self.value = value
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
