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
    weak var delegate: NapiEngineDelegate?

    /// A state in which `NapiEngine` currently is.
    fileprivate(set) var status: Status = .idle {
        didSet {
            delegate?.napiEngineDidChangeStatus(self)
        }
    }

    /// Contains all informations which tell what `NapiEngine` is currently processing.
    fileprivate(set) var statusInfo: StatusInfo?

    // MARK: Private

    fileprivate let directoryScanner = DirectoryScanner.self
    fileprivate let subtitleDownloader = SubtitleDownloader(languages: Preferences[.languages], providers: Preferences[.providers])
    fileprivate let subtitleConverter = SubtitleConverter()
    fileprivate let nameMatcher = NameMatcher()

    fileprivate var unprocessedVideoFiles = [URL]()
    fileprivate var currentVideoFile: URL!

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
    /// - Parameter urls: `URLs` to scan in order to find video files./Users/Morrs/Movies/Movies
    ///                   It can include both directories and files.
    func downloadSubtitles(forVideoFilesAt urls: [URL]) {
        unprocessedVideoFiles += directoryScanner.videoFiles(in: urls, shallowSearch: Preferences[.shallowSearch])

        initializeDownloadForNextVideo()
    }

    func cancel() {
        log.info("Canceling.")
        status = .canceling
        subtitleDownloader.cancel()
    }

    // MARK: - Private Functions

    // MARK: Downloading

    /// If there is a next video awaiting for subtitles, initialize search for it
    /// and remove from a videos to process query.
    fileprivate func initializeDownloadForNextVideo() {
        guard
            status != .canceling,
            subtitleDownloader.status == .ready,
            unprocessedVideoFiles.isNotEmpty
        else {
            log.info("Finished.")

            statusInfo = nil
            status = .idle
            delegate?.napiEngineDidFinish(self)

            return
        }

        currentVideoFile = unprocessedVideoFiles.removeFirst()

        log.info("Processing video file \"\(currentVideoFile.lastPathComponent)\". [\(unprocessedVideoFiles.count) left]")

        subtitleDownloader.searchSubtitles(forFileAt: currentVideoFile,
                                           skipAlreadyDownloadedLanguages: Preferences[.skipAlreadyDownloadedLanguages])
    }

    // MARK: Converting

    /// Takes `SubtitleEntity` and tries to change encoding of subtitles
    /// and/or convert subtitles to expected subtitle format.
    ///
    /// - Parameter subtitleEntity: `SubtitleEntity` with subtitles to convert.
    ///
    /// - Returns: Final format of subtitles based on current and expected format. 
    ///            If subtitles are in unsupported format `nil` is returned.
    fileprivate func convert(_ subtitleEntity: SubtitleEntity) -> SupportedSubtitleFormat? {
        guard
            let subtitlesFileInformation = FileInformation(url: subtitleEntity.url),
            var (subtitles, encoding) = subtitlesFileInformation.encodedString
        else {
            return nil
        }

        var fileNeedsWriting = false
        var finalSubtitleFormat: SupportedSubtitleFormat?

        convertion: do {
            try subtitleConverter.load(subtitles: subtitles)

            guard
                let expectedSubtitleFormat = Preferences[.expectedSubtitleFormat],
                Preferences[.convertSubtitles]
            else {
                finalSubtitleFormat = subtitleConverter.detectedSubtitleFormat
                break convertion
            }

            updateFrameRateInSubtitleConverter()
            subtitles = try subtitleConverter.convert(to: expectedSubtitleFormat)
            finalSubtitleFormat = expectedSubtitleFormat
            fileNeedsWriting = true
        } catch let error {
            log.error(error.localizedDescription)
        }

        log.info("Detected encoding \(encoding).")

        let expectedEncoding = Preferences[.expectedEncoding]
        if Preferences[.changeEncoding] && expectedEncoding != encoding {
            log.info("Changing encoding to \(expectedEncoding).")

            encoding = expectedEncoding
            fileNeedsWriting = true
        }

        if fileNeedsWriting {
            do {
                log.info("Saving modified subtitles.")

                try subtitles.write(to: subtitleEntity.url, atomically: true, encoding: encoding)
            } catch let error {
                log.error(error.localizedDescription)
            }
        }

        return finalSubtitleFormat
    }

    /// Clears current `frameRate` value in `subtitleConverter`
    /// and tries to determine a new value if specified.
    private func updateFrameRateInSubtitleConverter() {
        subtitleConverter.frameRate = nil

        guard let videoFileInformation = FileInformation(url: currentVideoFile) else {
            return
        }

        if Preferences[.tryToDetermineFrameRate] {
            log.info("Trying to determine video frame rate.")
            if let detectedFrameRate = videoFileInformation.frameRate {
                subtitleConverter.frameRate = detectedFrameRate
                log.info("Detected frame rate: \(detectedFrameRate).")
            } else if Preferences[.useBackupFrameRate] {
                subtitleConverter.frameRate = Preferences[.backupFrameRate]
                log.info("Using backup frame rate: \(Preferences[.backupFrameRate]).")
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
    fileprivate func move(_ subtitleEntity: SubtitleEntity, pathExtension: String?) -> URL {
        do {
            let movedSubtitles = try nameMatcher.url(for: subtitleEntity, matchingFileAt: currentVideoFile)
            try nameMatcher.move(subtitleEntity, toMatchFileAt: currentVideoFile, customExtension: pathExtension)

            return movedSubtitles.appendingPathExtension(pathExtension ?? "")
        } catch let error {
            log.error(error.localizedDescription)

            return subtitleEntity.url
        }
    }
}

// MARK: - Types

extension NapiEngine {

    /// Indicates a state of `NapiEngine`.
    /// By this value you can tell what `NapiEngine` is currently doing.
    enum Status {

        /// Nothing is happening.
        case idle

        /// Search request has been send and engine is waiting for a response.
        case searching

        /// Download request has been send and engine is waiting for subtitles.
        case downloading

        /// Subtitles are on disk and engine is converting and detecing subtitles format.
        case processing

        /// Subtitles are ready and engine is moving them to a destination folder.
        case moving

        /// Engine is trying to cancel futher operations.
        case canceling
    }

    /// A set of informations about what is being currently processed.
    struct StatusInfo {

        /// A name of `SubtitleProvider` used to search and download subtitles.
        var subtitleProviderName: String

        /// A language of currently processed subtitles.
        var language: Language

        /// A `URL` to a video file, which currently is a pattern video.
        var videoURL: URL
    }
}

// MARK: - SubtitleDownloaderDelegate

extension NapiEngine: SubtitleDownloaderDelegate {
    func subtitleDownloader(_ subtitleDownloader: SubtitleDownloader, willSearchSubtitlesFor searchCriteria: SearchCriteria, using subtitleProvider: SubtitleProvider) {
        statusInfo = StatusInfo(subtitleProviderName: subtitleProvider.name, language: searchCriteria.language, videoURL: currentVideoFile)

        log.info("Searching subtitles in \(searchCriteria.language.currentLocaleName ?? searchCriteria.language.isoCode).")
        status = .searching
    }


    func subtitleDownloader(_ subtitleDownloader: SubtitleDownloader, willDownloadSubtitlesFor searchCriteria: SearchCriteria, using subtitleProvider: SubtitleProvider) {
        status = .downloading
    }

    func subtitleDownloader(_ subtitleDownloader: SubtitleDownloader, didDownloadSubtitlesFor searchCriteria: SearchCriteria, using subtitleProvider: SubtitleProvider) {
        if let subtitlesToConvert = subtitleDownloader.downloadedSubtitles.last {
            status = .processing
            let finalSubtitleFormat = convert(subtitlesToConvert)

            status = .moving
            let subtitlesURL = move(subtitlesToConvert, pathExtension: finalSubtitleFormat?.type.fileExtension)

            delegate?.napiEngine(self, didProvideSubtitlesAt: subtitlesURL)
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
