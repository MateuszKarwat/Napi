//
//  DownloadSubtitlesOperation.swift
//  Napi
//
//  Created by Mateusz Karwat on 23/10/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

class URLRequestOperation: Operation {
    var request: URLRequest
    var completion: (Data?, URLResponse?, Error?) -> Void

    enum State: String {
        case ready
        case executing
        case finished

        var keyPath: String {
            return "is" + self.rawValue.capitalized
        }
    }

    var state: State = .ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }

        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }

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

    override func start() {
        if isCancelled {
            state = .finished
            return
        }

        main()
    }

    override func main() {
        state = .executing
        URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, response, error)
            state = .finished
        }
    }

    override func cancel() {
        state = .finished
    }
}
