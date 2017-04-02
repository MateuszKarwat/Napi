//
//  Created by Mateusz Karwat on 02/04/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

protocol NapiEngineDelegate: class {

    /// Called whenever `NapiEngine` will search next subtitles.
    ///
    /// - Parameters:
    ///   - napiEngine:          `NapiEngine` which will begin searching.
    ///   - processingComponent: A set of values which will be used to create a search query.
    func napiEngine(_ napiEngine: NapiEngine, willSearchSubtitlesFor processingComponent: NapiEngine.ProcessingComponent)

    /// Called whenever `NapiEngine` will download subtitles.
    ///
    /// - Parameters:
    ///   - napiEngine:          `NapiEngine` which will begin downloading.
    ///   - processingComponent: A set of values which will be used to create a download query.
    func napiEngine(_ napiEngine: NapiEngine, willDownloadSubtitlesFor processingComponent: NapiEngine.ProcessingComponent)

    /// Called whenever `NapiEngine` will convert subtitles.
    ///
    /// - Parameters:
    ///   - napiEngine:          `NapiEngine` which will begin converting.
    ///   - processingComponent: A set of values which will be used to convert subtitles.
    func napiEngine(_ napiEngine: NapiEngine, willConvertSubtitlesFor processingComponent: NapiEngine.ProcessingComponent)

    /// Called whenever `NapiEngine` will move subtitles to a destination `URL`.
    ///
    /// - Parameters:
    ///   - napiEngine:          `NapiEngine` which will begin file operations like renaming.
    ///   - processingComponent: A set of values which will be used to determine name and destination of subtitles.
    func napiEngine(_ napiEngine: NapiEngine, willMoveSubtitlesFor processingComponent: NapiEngine.ProcessingComponent)

    /// Called whenever `NapiEngine` whenever there is no more search and download requests for a specific video file.
    ///
    /// - Parameters:
    ///   - napiEngine:          `NapiEngine` which did all the requests.
    ///   - processingComponent: A set of values which used to search, download, convert and move subtitles.
    func napiEngine(_ napiEngine: NapiEngine, didMatchSubtitlesFor processingComponent: NapiEngine.ProcessingComponent)

    /// Called when `NapiEngine` has no more videos to check.
    ///
    /// - Parameter napiEngine: `NapiEngine` which finished its execution.
    func napiEngineDidFinish(_ napiEngine: NapiEngine)
}

/// Default, empty implementations of `NapiEngineDelegate`.
extension NapiEngineDelegate {
    func napiEngine(_ napiEngine: NapiEngine, willSearchSubtitlesFor processingComponent: NapiEngine.ProcessingComponent) { }
    func napiEngine(_ napiEngine: NapiEngine, willDownloadSubtitlesFor processingComponent: NapiEngine.ProcessingComponent) { }
    func napiEngine(_ napiEngine: NapiEngine, willConvertSubtitlesFor processingComponent: NapiEngine.ProcessingComponent) { }
    func napiEngine(_ napiEngine: NapiEngine, willMoveSubtitlesFor processingComponent: NapiEngine.ProcessingComponent) { }
    func napiEngine(_ napiEngine: NapiEngine, didMatchSubtitlesFor processingComponent: NapiEngine.ProcessingComponent) { }
    func napiEngineDidFinish(_ napiEngine: NapiEngine) { }
}
