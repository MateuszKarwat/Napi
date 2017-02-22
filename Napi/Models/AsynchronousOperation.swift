//
//  Created by Mateusz Karwat on 19/02/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

/// `AsynchronousOperation` aims to ease the pain commonly encountered
/// when having to subclass `Operation` for async tasks.
///
/// - Important: Don't forget to call `finish()` when async task is completed.
class AsynchronousOperation: Operation {

    // MARK: - Types

    enum State: String {
        case ready, executing, finished

        var keyPath: String {
            return "is" + self.rawValue.capitalized
        }
    }

    // MARK: - Properties

    var state: State {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }

        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }

    let executionBlock: (AsynchronousOperation) -> Void

    // MARK: - Initializers

    init(executionBlock: @escaping (AsynchronousOperation) -> Void) {
        self.state = .ready
        self.executionBlock = executionBlock
        super.init()
    }

    // MARK: - Foundation.Operation

    override var isReady: Bool {
        return super.isReady && state == .ready
    }

    override var isExecuting: Bool {
        return state == .executing
    }

    override var isFinished: Bool {
        return state == .finished
    }

    override var isAsynchronous: Bool {
        return true
    }

    // MARK: - Execution

    override func start() {
        if isCancelled {
            state = .finished
        } else {
            state = .executing
            main()
        }
    }

    override func main() {
        executionBlock(self)
    }

    override func cancel() {
        super.cancel()
        state = .finished
    }

    final func finish() {
        state = .finished
    }
}
