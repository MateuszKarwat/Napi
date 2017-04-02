//
//  Created by Mateusz Karwat on 21/03/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

/// A core class to download, search and postprocess subtitles.
/// Class has an initializer without any parameter, because every step
/// and condition is determined based on `UserDefaults`.
/// All preferences used in this class can be found in `Defaults`.
/// Once class is initialized it can take urls to scan and process.
/// Any url passed to this engine is put at the end of a process queue
/// and consumed in FIFO order.
/// 
/// - Important: It is a good practice to set this engine to `nil` when it's no longer
/// needed, because some `SubtitleProvider`s need to send logout request in order to
/// avoid token timeouts.
final class NapiEngine {

    // MARK: - Properties

    // MARK: Public

    /// A reference to object implementing `NapiEngineDelegate` protocol.
    var delegate: NapiEngineDelegate?

    // MARK: Private

    fileprivate let directoryScanner = DirectoryScanner.self
    fileprivate let subtitleDownloader = SubtitleDownloader(languages: Preferences[.languages], providers: Preferences[.providers])
    fileprivate let subtitleConverter = SubtitleConverter()
    fileprivate let nameMatcher = NameMatcher()

    fileprivate var unprocessedVideoFiles = [URL]()
    fileprivate var currentlyProcessedVideo: URL?

    // MARK: - Initialization

    init() {
        configureNameMatcher()
        configureSubtitleConverter()
        configureSubtitleDownloader()
    }

    private func configureNameMatcher() {
        nameMatcher.appendLanguageCode = Preferences[.appendLanguageCode]
        nameMatcher.nameConflictAction = Preferences[.nameConflictAction]
    }

    private func configureSubtitleConverter() {
        subtitleConverter.correctPunctuation = Preferences[.correctPunctuation]
        subtitleConverter.mergeAdjacentWhitespaces = Preferences[.mergeAdjacentWhitespaces]
    }

    private func configureSubtitleDownloader() {
        subtitleDownloader.delegate = self
        subtitleDownloader.downloadLimit = Preferences[.downloadLimit]
    }

    // MARK: - Public Functions

    /// Scanns all `URLs` to find video files and add them to a queue.
    /// Then the queue is processed in FIFO order.
    ///
    /// - Parameter urls: `URLs` to scan in order to find video files.
    ///                   It can include both directories and files.
    func downloadSubtitles(forVideoFilesAt urls: [URL]) {
        unprocessedVideoFiles += directoryScanner.videoFiles(in: urls, shallowSearch: Preferences[.shallowSearch])

        initializeDownloadForNextVideo()
    }

    func cancel() {
        // TODO: Implement option to cancel an execution of the engine.
    }

    // MARK: - Private Functions

    // MARK: Downloading

    /// If there is a next video awaiting for subtitles, initialize search for it
    /// and remove from a videos to process query.
    fileprivate func initializeDownloadForNextVideo() {
        guard
            subtitleDownloader.status == .ready,
            unprocessedVideoFiles.isNotEmpty else {
                delegate?.napiEngineDidFinish(self)
                return
        }

        let nextVideoFileToProcess = unprocessedVideoFiles.removeFirst()

        currentlyProcessedVideo = nextVideoFileToProcess
        subtitleDownloader.searchSubtitles(forFileAt: nextVideoFileToProcess,
                                           skipAlreadyDownloadedLanguages: Preferences[.skipAlreadyDownloadedLanguages])
    }

    // MARK: Converting

    /// Takes `SubtitleEntity` and tries to change encoding of subtitles
    /// and/or convert subtitles to expected subtitle format.
    ///
    /// - Parameter subtitleEntity: `SubtitleEntity` with subtitles to convert.
    fileprivate func convert(_ subtitleEntity: SubtitleEntity, usedSubtitleFormat: inout SupportedSubtitleFormat?) {
        guard
            let subtitlesFileInformation = FileInformation(url: subtitleEntity.url),
            var (subtitles, encoding) = subtitlesFileInformation.encodedString else {
                return
        }

        var isWritingToFileNeeded = false

        convertion: do {
            try subtitleConverter.load(subtitles: subtitles)

            guard
                let expectedSubtitleFormat = Preferences[.expectedSubtitleFormat],
                expectedSubtitleFormat != subtitleConverter.detectedSubtitleFormat,
                Preferences[.convertSubtitles]
                else {
                    usedSubtitleFormat = subtitleConverter.detectedSubtitleFormat
                    break convertion
            }

            updateFrameRateInSubtitleConverter()
            subtitles = try subtitleConverter.convert(to: expectedSubtitleFormat)
            usedSubtitleFormat = expectedSubtitleFormat
            isWritingToFileNeeded = true
        } catch { }

        let expectedEncoding = Preferences[.expectedEncoding]
        if Preferences[.changeEncoding] && expectedEncoding != encoding {
            encoding = expectedEncoding
            isWritingToFileNeeded = true
        }

        if isWritingToFileNeeded {
            do {
                try subtitles.write(to: subtitleEntity.url, atomically: true, encoding: encoding)
            } catch { }
        }
    }

    /// Clears current `frameRate` value in `subtitleConverter`
    /// and tries to determine a new value if specified.
    private func updateFrameRateInSubtitleConverter() {
        subtitleConverter.frameRate = nil

        guard
            let videoURL = currentlyProcessedVideo,
            let videoFileInformation = FileInformation(url: videoURL)
        else {
            return
        }

        if Preferences[.tryToDetermineFrameRate] {
            if let detectedFrameRate = videoFileInformation.frameRate {
                subtitleConverter.frameRate = detectedFrameRate
            } else if Preferences[.useBackupFrameRate] {
                subtitleConverter.frameRate = Preferences[.backupFrameRate]
            }
        }
    }

    // MARK: Matching

    /// Final step of an engine. It moves subtitles to a destination folder
    /// and changes name of subtitles file according to matching rules.
    ///
    /// - Parameters:
    ///   - subtitleEntity: Subtitles to move from temporary folder.
    ///   - pathExtension:  Extension of a final subtitles file.
    ///
    /// - Returns: A `URL` to the final subtitles.
    ///
    /// - Throws: `NameMatchingError` or `FileManager`'s error.
    fileprivate func match(_ subtitleEntity: SubtitleEntity, pathExtension: String?) throws -> URL {
        guard let videoURL = currentlyProcessedVideo else {
            return subtitleEntity.url
        }

        let movedSubtitles = try nameMatcher.url(for: subtitleEntity, matchingFileAt: videoURL)

        try nameMatcher.move(subtitleEntity, toMatchFileAt: videoURL, customExtension: pathExtension)

        return movedSubtitles.appendingPathExtension(pathExtension ?? "")
    }
}

// MARK: - ProcessingComponent Type

extension NapiEngine {

    /// A set of informations about what is being currently processed.
    struct ProcessingComponent {

        /// A name of `SubtitleProvider` used to search and download subtitles.
        let subtitleProviderName: String

        /// A language of currently processed subtitles.
        let language: Language

        /// A `URL` to a video file, which currently is a pattern video.
        let videoURL: URL

        /// A `URL` to the downloaded subtitles if any.
        let subtitlesURL: URL?

        /// Creates and returnes a new instance of `ProcessingComponent`.
        init(searchCriteria: SearchCriteria, subtitleProvider: SubtitleProvider, subtitlesURL: URL? = nil) {
            self.subtitleProviderName = subtitleProvider.name
            self.language = searchCriteria.language
            self.videoURL = searchCriteria.fileURL
            self.subtitlesURL = subtitlesURL
        }
    }
}

// MARK: - SubtitleDownloaderDelegate

extension NapiEngine: SubtitleDownloaderDelegate {
    func subtitleDownloader(_ subtitleDownloader: SubtitleDownloader,
                            willSearchSubtitlesFor searchCriteria: SearchCriteria,
                            using subtitleProvider: SubtitleProvider) {
        let processingComponent = ProcessingComponent(searchCriteria: searchCriteria, subtitleProvider: subtitleProvider)
        delegate?.napiEngine(self, willSearchSubtitlesFor: processingComponent)
    }

    func subtitleDownloader(_ subtitleDownloader: SubtitleDownloader,
                            willDownloadSubtitlesFor searchCriteria: SearchCriteria,
                            using subtitleProvider: SubtitleProvider) {
        let processingComponent = ProcessingComponent(searchCriteria: searchCriteria, subtitleProvider: subtitleProvider)
        delegate?.napiEngine(self, willDownloadSubtitlesFor: processingComponent)
    }

    func subtitleDownloader(_ subtitleDownloader: SubtitleDownloader,
                            didDownloadSubtitlesFor searchCriteria: SearchCriteria,
                            using subtitleProvider: SubtitleProvider) {
        if let subtitlesToConvert = subtitleDownloader.downloadedSubtitles.last {
            let processingComponent = ProcessingComponent(searchCriteria: searchCriteria, subtitleProvider: subtitleProvider)

            delegate?.napiEngine(self, willConvertSubtitlesFor: processingComponent)

            var subtitleFormat: SupportedSubtitleFormat?
            convert(subtitlesToConvert, usedSubtitleFormat: &subtitleFormat)

            delegate?.napiEngine(self, willMoveSubtitlesFor: processingComponent)

            let subtitlesURL: URL
            do {
                subtitlesURL = try match(subtitlesToConvert, pathExtension: subtitleFormat?.type.fileExtension)
            } catch {
                subtitlesURL = subtitlesToConvert.url
            }

            delegate?.napiEngine(self, didMatchSubtitlesFor: ProcessingComponent(searchCriteria: searchCriteria,
                                                                                 subtitleProvider: subtitleProvider,
                                                                                 subtitlesURL: subtitlesURL))
        }
    }

    func subtitleDownloaderDidChangeStatus(_ subtitleDownloader: SubtitleDownloader) {
        switch subtitleDownloader.status {
        case .ready:
            initializeDownloadForNextVideo()
        default:
            break
        }
    }
}




