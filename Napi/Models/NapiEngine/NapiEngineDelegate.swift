//
//  Created by Mateusz Karwat on 02/04/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

protocol NapiEngineDelegate: class {

    /// Called whenever `NapiEngine` changes its status.
    ///
    /// - Parameter napiEngine: `NapiEngine` which changed its status.
    func napiEngineDidChangeStatus(_ napiEngine: NapiEngine)

    /// Called whenever `NapiEngine` found, downloaded, processed and moved to correct location subtitles.
    ///
    /// - Parameters:
    ///   - napiEngine: `NapiEngine` which did all the requests.
    ///   - url:        A path to brand new subtitles.
    func napiEngine(_ napiEngine: NapiEngine, didProvideSubtitlesAt url: URL)

    /// Called when `NapiEngine` has no more videos to check.
    ///
    /// - Parameter napiEngine: `NapiEngine` which finished its execution.
    func napiEngineDidFinish(_ napiEngine: NapiEngine)
}

/// Default, empty implementations of `NapiEngineDelegate`.
extension NapiEngineDelegate {
    func napiEngineDidChangeStatus(_ napiEngine: NapiEngine) { }
    func napiEngine(_ napiEngine: NapiEngine, didProvideSubtitlesAt url: URL) { }
    func napiEngineDidFinish(_ napiEngine: NapiEngine) { }
}
