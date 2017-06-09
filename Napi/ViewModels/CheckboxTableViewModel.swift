//
//  Created by Mateusz Karwat on 25/05/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import AppKit
import Foundation

final class CheckboxTableViewModel {

    /// Text visible above the table view.
    /// It's used to explain table view's content and options.
    var description = ""

    /// Specifies if table view should present extra column with
    /// thumbnail image between checkbox and text.
    var showCellImage = false

    /// A completion block called when `apply` action is triggered.
    /// Passed array contains all selected values in displayed order.
    var onApply: (([Any]) -> Void)?

    /// A completion block called when `cancel` action is triggered.
    var onCancel: (() -> Void)?

    /// All elements to display in a `CheckboxTableView`.
    private var elements: [Element]

    init(elements: [Element]) {
        self.elements = elements
    }

    // MARK: - Outputs

    /// Returns a total numer of rows to display.
    var numberOfRows: Int {
        return elements.count
    }

    /// Returns all selected elements.
    var selectedElements: [Element] {
        return elements.filter { $0.isSelected }
    }

    /// Returns an element at a specific index.
    ///
    /// - Important: `index` must be lower than `numberOfElements`.
    func element(at index: Int) -> Element? {
        guard elements.startIndex ..< elements.endIndex ~= index else {
            return nil
        }

        return elements[index]
    }

    // MARK: - Input

    /// Should be called when ever checkbox changes.
    ///
    /// - Parameter index: Index of changed checkbox.
    ///
    /// - Important: `index` must be in `0 ..< numberOfElements`.
    func selectionDidChange(at index: Int) {
        elements[index].isSelected = !elements[index].isSelected
    }

    /// Should be called whenever cells are dragged to different place.
    ///
    /// - Parameters:
    ///   - indexSet: A set of indexes which have been moved.
    ///   - index:    Destination index of dragged elements.
    @discardableResult
    func didMoveElements(at movedIndexes: [Int], to destinationIndex: Int) -> [Int] {
        let movedElements = elements.removeElements(at: IndexSet(movedIndexes))
        let numberOfIndexesLowerThanDestinationIndex = movedIndexes
            .sorted()
            .prefix { $0 < destinationIndex }
            .count
        let indexToInsertElements = max(0, destinationIndex - numberOfIndexesLowerThanDestinationIndex)
        let indexesToSelect = movedElements
            .enumerated()
            .map { index, _ in index + indexToInsertElements }

        elements.insert(contentsOf: movedElements, at: indexToInsertElements)

        return indexesToSelect
    }

    func cancelButtonClicked() {
        onCancel?()
    }

    func applyButtonClicked() {
        onApply?(selectedElements.map { $0.value })
    }
}

// MARK: - Types

extension CheckboxTableViewModel {

    /// Represents a set of data required to properly display `CheckboxTableView`.
    struct Element {

        /// Any value to store when items are moved around.
        let value: Any

        /// Specifies if a checkbox is visible for specific element.
        var isSelected: Bool

        /// If `showCellImage` is set to `true`, this image will be used.
        let image: NSImage?

        /// A text which is displayed in a table view for specific element.
        let description: String
    }
}
