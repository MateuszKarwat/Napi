//
//  Created by Mateusz Karwat on 08/03/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Cocoa
import Foundation

/// Delegate for `DraggingDestinationView`.
protocol DraggingDestinationViewDelegate: class {

    /// Called when dragging session ends and there is at lease one URL.
    ///
    /// - Parameters:
    ///   - view: A view which calls this method.
    ///   - urls: An array of URLs corresponding to dragged files and folders.
    func draggingDestinationView(_ view: DraggingDestinationView, didReceiveURLs urls: [URL])
}

/// View which responds to dragging operations.
class DraggingDestinationView: NSView {

    struct Appearance {
        static let lineWidth: CGFloat = 7.5
    }

    // MARK: - Properties

    weak var delegate: DraggingDestinationViewDelegate?

    private var isReceivingDrag = false {
        didSet {
            needsDisplay = true
        }
    }

    // MARK: - Lifecycle

    override func awakeFromNib() {
        register(forDraggedTypes: [NSURLPboardType])
    }

    // MARK: - Dragging Session

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        isReceivingDrag = true
        return .generic
    }

    override func draggingExited(_ sender: NSDraggingInfo?) {
        isReceivingDrag = false
    }

    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return sender.draggingPasteboard().canReadObject(forClasses: [NSURL.self], options: nil)
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        isReceivingDrag = false

        let pasteboard = sender.draggingPasteboard()

        if let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL], urls.isNotEmpty {
            delegate?.draggingDestinationView(self, didReceiveURLs: urls)
            return true
        }

        return false
    }

    // MARK: - Layout

    override func draw(_ dirtyRect: NSRect) {
        if isReceivingDrag {
            NSColor.selectedControlColor.set()

            let path = NSBezierPath(rect: bounds)
            path.lineWidth = Appearance.lineWidth
            path.stroke()
        }
    }
}
