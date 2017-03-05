//
//  Created by Mateusz Karwat on 05/03/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

/// A `Struct` which provides easy way to create
/// `AsynchronousOperation`s for search and download requests.
struct SubtitleOperation {

    /// Desired language of subtitles.
    let language: Language

    /// `SubtitleProvider` used for search and download requests.
    let provider: SubtitleProvider

    /// Creates a new instance of `SubtitleOperation`.
    init(language: Language, provider: SubtitleProvider) {
        self.language = language
        self.provider = provider
    }

    /// Creates new `AsynchronousOperation` which makes a search request
    /// using `language` and `provider`.
    ///
    /// - Parameters:
    ///   - url:               A `URL` for a file, which request is going to be done for.
    ///   - completionHandler: A completion handled called when request is done.
    ///
    /// - Returns: New `AsynchronousOperation` instance ready to be push into `OperationQueue`.
    func searchOperation(forFileAt url: URL, completionHandler: @escaping ([SubtitleEntity]?) -> Void) -> AsynchronousOperation? {
        guard let searchCriteria = SearchCriteria(fileURL: url, language: language) else {
            completionHandler(nil)
            return nil
        }

        return AsynchronousOperation { operation in
            self.provider.searchSubtitles(using: searchCriteria) { entities in
                completionHandler(entities)
                operation.finish()
            }
        }
    }

    /// Creates new `AsynchronousOperation` which makes a download request
    /// using `language` and `provider`.
    ///
    /// - Parameters:
    ///   - subtitleEntity:    A `SubtitleEntity` returned from `searchOperation(forFileAt: completionHandler:)`.
    ///   - completionHandler: A completion handled called when request is done.
    ///
    /// - Returns: New `AsynchronousOperation` instance ready to be push into `OperationQueue`.
    func downloadOperation(for subtitleEntity: SubtitleEntity, completionHandler: @escaping (SubtitleEntity?) -> Void) -> AsynchronousOperation? {
        return AsynchronousOperation { operation in
            self.provider.download(subtitleEntity) { newEntity in
                completionHandler(newEntity)
                operation.finish()
            }
        }
    }
}
