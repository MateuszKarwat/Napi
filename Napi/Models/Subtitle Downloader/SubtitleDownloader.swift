//
//  Created by Mateusz Karwat on 05/03/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

/// A class to search and download subtitles for specified file,
/// using an order determined by passed `Languages` and `SubtitleProviders`. 
final class SubtitleDownloader {

    // MARK: - Types

    /// Defines when `SubtitleDownloader` should stop making next
    /// search and download request in order to provide more results.
    ///
    /// - none:             Never stop. Search and download everything.
    /// - first:            Stop when first subtitles are found.
    /// - firstPerLanguage: Stop when for each language there is a result (if any).
    enum DownloadLimit: String {
        case none
        case first
        case firstPerLanguage
    }

    /// Indicates a state in which `SubtitleDownloader` currently is.
    ///
    /// - ready:      `SubtitleDownloader` doesn't do any job. It's waiting
    ///               for next search call.
    /// - executing:  `SubtitleDownloader` is search and downloading subtitles.
    ///               When everything is done, state will be changed to `ready`.
    /// - cancelling: `SubtitleDownloader` is trying to cancel all operations.
    ///               Once all operations are cancelled, state will be changed to `ready`.
    enum State {
        case ready
        case executing
        case cancelling
    }

    // MARK: - Properties

    /// Defines when `SubtitleDownloader` should stop making next
    /// search and download request in order to provide more results.
    var downloadLimit: DownloadLimit = .firstPerLanguage

    /// A reference to object implementing `SubtitleDownloaderDelegate` protocol.
    weak var delegate: SubtitleDownloaderDelegate? = nil

    /// Currenlty downloaded subtitles. This array probably is going to change
    /// when `state` is `executing`. If `state` is `ready`, this property won't change.
    /// It's cleared every time `searchSubtitles(forFileAt:skipAlreadyDownloadedLanguages:)`
    /// is called, so make sure to make a copy of it, before calling that method.
    private(set) var downloadedSubtitles = [SubtitleEntity]()

    /// Indicates a state in which `SubtitleDownloader` currently is.
    /// Delegate's method `subtitleDownloaderDidChangeStatus(:)` is called for every
    /// new state.
    private(set) var state: State = .ready {
        didSet {
            if state != oldValue {
                delegate?.subtitleDownloaderDidChangeStatus(self)
            }
        }
    }

    // MARK: Private Properties

    /// Queue which is used to execute all search and download operations.
    private let queue = OperationQueue()

    /// All `SubtitleOperations` generated based on passed 
    /// `languages` and `providers` to the initializer.
    private let allSubtitleOperations: [SubtitleOperation]

    /// A reference to a video file which subtitles are needed for.
    private var currentFileURL: URL?

    /// `SubtitleOperation`s waiting to be processed 
    /// in order to make search and download request.
    private var remainingSubtitleOperations: [SubtitleOperation]

    /// `SubtitleOperation` which currently is being processed.
    private var currentSubtitleOperation: SubtitleOperation?

    /// Every time search request from `currentSubtitleOperation` returns any
    /// `SubtitleEntity`, it is appended to this array. Then this array is consumed
    /// to make next download request.
    private var subtitleEntitiesFromLastSearch = [SubtitleEntity]()

    // MARK: - Lifecycle

    /// Creates a new instance of `SubtitleDownloader`.
    /// Passed `languages` and `providers` are used to create order of search requests.
    /// First, `SubtitleDownloader` will execute all operations for first language and 
    /// every provider in order they are passed. Then, second language will be taken
    /// with all subtitle providers and so on.
    ///
    /// For example:
    ///
    ///     let languages = [Language(isoCode: "pl"), Language(isoCode: "en")]
    ///     let providers = [OpenSubtitles(), Napisy24()]
    ///     _ = SubtitleDownloader(languages: languages, providers: providers)
    ///
    /// Will create `SubtitleDownloader` instance with requests order like this:
    ///
    ///     // [("pl", OpenSubtitles()), ("pl", Napisy24()), ("en", OpenSubtitles()), ("en", Napisy24())]
    ///
    /// This will be the exact order in which all further search and download request
    /// will take place.
    ///
    /// - Parameters:
    ///   - languages: All languages to find.
    ///   - providers: All `SubtitleProvider`s used for subtitle requests.
    init(languages: [Language], providers: [SubtitleProvider]) {
        var subtitleOperations = [SubtitleOperation]()

        languages.forEach { language in
            providers.forEach{ provider in
                subtitleOperations.append(SubtitleOperation(language: language, provider: provider))
            }
        }

        allSubtitleOperations = subtitleOperations
        remainingSubtitleOperations = subtitleOperations

        queue.name = "\(self)"
        queue.maxConcurrentOperationCount = 1
    }

    // MARK: - Methods

    /// Main method for making search requests. It changes `SubtitleDownloader` `state`
    /// to `execution` and begins search and download operations in order specified
    /// during initialization process.
    ///
    /// - Parameters:
    ///   - url:                            A `URL` to a pattern file.
    ///   - skipAlreadyDownloadedLanguages: Defines if `SubtitleDownloader` should skip
    ///                                     languages which are already downloaded and
    ///                                     located in the same directory as a pattern file.
    ///                                     If set to `false` it will try to search them anyway.
    ///
    /// - Important: Method leaves its execution immediately if `state` is not `ready`.
    func searchSubtitles(forFileAt url: URL, skipAlreadyDownloadedLanguages: Bool) {
        guard state == .ready else {
            return
        }

        currentFileURL = url
        downloadedSubtitles = []
        currentSubtitleOperation = nil
        subtitleEntitiesFromLastSearch = []
        remainingSubtitleOperations = allSubtitleOperations

        if skipAlreadyDownloadedLanguages {
            let alreadyDownloadedLanguages = DirectoryScanner.associatedLanguagesWithFile(at: url)
            remainingSubtitleOperations = remainingSubtitleOperations.filter {
                !alreadyDownloadedLanguages.contains($0.language)
            }
        }

        state = .executing
        performSearchOperation()
    }

    /// Begins a process of cancelling all currently active operations
    /// and discards all futhers operations. It immediately changes `state` to `cancelling`.
    /// Once all above tasks are done, `state` will be set back to `ready`.
    func cancel() {
        state = .cancelling
        queue.cancelAllOperations()
    }

    // MARK: Private Methods

    /// Tries to perform next search operations if possible and trigger download operations accordingly.
    /// If it's not possible, it will change `state` to `ready`. It can happen only if:
    /// - there is no more search operations to create
    /// - `cancel()` method has been called
    private func performSearchOperation() {
        prepareForNextSearchOperation()

        guard
            state != .cancelling,
            let url = currentFileURL,
            let subtitleOperation = currentSubtitleOperation else {
                state = .ready
                return
        }

        let searchOperation = subtitleOperation.searchOperation(forFileAt: url) { [weak self] entities in
            guard let strongSelf = self else {
                return
            }

            if strongSelf.state != .cancelling {
                if let entities = entities, entities.isNotEmpty {
                    strongSelf.subtitleEntitiesFromLastSearch = entities
                    strongSelf.notifyDelegate(subtitleDownloader: .didFindSubtitles)
                } else {
                    strongSelf.subtitleEntitiesFromLastSearch = []
                }
            }

            strongSelf.performDownloadOperation()
        }

        if let searchOperation = searchOperation {
            notifyDelegate(subtitleDownloader: .willSearchSubtitles)

            if state != .cancelling {
                queue.addOperation(searchOperation)
                return
            }
        }

        performSearchOperation()
    }

    /// It's called by `performSearchOperation()` in order to download new search results.
    /// If it's not possible, it will finish its execution. It can happen only if:
    /// - there is no more download operations to create
    /// - `downloadLimit` has been satisfied
    /// - `cancel()` method has been called
    private func performDownloadOperation() {
        prepareForNextDownloadOperation()

        guard
            state != .cancelling,
            let subtitleOperation = currentSubtitleOperation,
            let entityToDownload = subtitleEntitiesFromLastSearch.first else {
                performSearchOperation()
                return
        }

        subtitleEntitiesFromLastSearch.removeFirst()

        let downloadOperation = subtitleOperation.downloadOperation(for: entityToDownload) { [weak self] entity in
            guard let strongSelf = self else {
                return
            }

            if let entity = entity, strongSelf.state != .cancelling {
                strongSelf.downloadedSubtitles.append(entity)
                strongSelf.notifyDelegate(subtitleDownloader: .didDownloadSubtitles)
            }

            strongSelf.performDownloadOperation()
        }

        if let downloadOperation = downloadOperation, state != .cancelling {
            notifyDelegate(subtitleDownloader: .willDownloadSubtitles)

            if state != .cancelling {
                queue.addOperation(downloadOperation)
                return
            }
        }

        performDownloadOperation()
    }

    /// Removes all remaining `SubtitleOperations` from further process based on
    /// `downloadLimit`, clears `subtitleEntitiesFromLastSearch` and assigns next
    /// `SubtitleOperation` to `currentSubtitleOperation` for further use.
    private func prepareForNextSearchOperation() {
        subtitleEntitiesFromLastSearch = []

        switch downloadLimit {
        case .first:
            if downloadedSubtitles.isNotEmpty {
                remainingSubtitleOperations = []
            }
        case .firstPerLanguage:
            let downloadedLanguages = downloadedSubtitles.map { $0.language }

            remainingSubtitleOperations = remainingSubtitleOperations.filter {
                !downloadedLanguages.contains($0.language)
            }
        case .none:
            break
        }

        currentSubtitleOperation = remainingSubtitleOperations.first

        if remainingSubtitleOperations.isNotEmpty {
            remainingSubtitleOperations.removeFirst()
        }
    }

    /// Removes all remaining `subtitleEntitiesFromLastSearch` from further process based on
    /// `downloadLimit`.
    private func prepareForNextDownloadOperation() {
        switch downloadLimit {
        case .first:
            if downloadedSubtitles.isNotEmpty {
                subtitleEntitiesFromLastSearch = []
            }
        case .firstPerLanguage:
            let downloadedLanguages = downloadedSubtitles.map { $0.language }

            subtitleEntitiesFromLastSearch = subtitleEntitiesFromLastSearch.filter {
                !downloadedLanguages.contains($0.language)
            }
        case .none:
            break
        }
    }

    // MARK: - Delegate

    /// An action which `SubtitleDownloader` should inform about.
    private enum SubtitleDownloaderAction {
        case willSearchSubtitles
        case didFindSubtitles
        case willDownloadSubtitles
        case didDownloadSubtitles
    }

    /// A wrapper method to send methods to a delegate in an easier way.
    ///
    /// - Parameter action: An action which `SubtitleDownloader` should inform about.
    private func notifyDelegate(subtitleDownloader action: SubtitleDownloaderAction) {
        guard
            let delegate = delegate,
            let fileURL = currentFileURL,
            let language = currentSubtitleOperation?.language,
            let provider = currentSubtitleOperation?.provider,
            let searchCriteria = SearchCriteria(fileURL: fileURL, language: language) else {
                return
        }

        switch action {
        case .willSearchSubtitles:
            delegate.subtitleDownloader(self, willSearchSubtitlesFor: searchCriteria, using: provider)
        case .didFindSubtitles:
            delegate.subtitleDownloader(self, didFindSubtitlesFor: searchCriteria, using: provider)
        case .willDownloadSubtitles:
            delegate.subtitleDownloader(self, willDownloadSubtitlesFor: searchCriteria, using: provider)
        case .didDownloadSubtitles:
            delegate.subtitleDownloader(self, didDownloadSubtitlesFor: searchCriteria, using: provider)
        }
    }
}
