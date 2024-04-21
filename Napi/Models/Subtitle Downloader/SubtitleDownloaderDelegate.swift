//
//  Created by Mateusz Karwat on 05/03/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

protocol SubtitleDownloaderDelegate: AnyObject {

    /// Called when `SubtitleDownloader` is going to search for subtitles.
    ///
    /// - Parameters:
    ///   - subtitleDownloader: `SubtitleDownloader` which begins searching.
    ///   - searchCriteria:     `SearchCriteria` which tells what subtitles it will search for.
    ///   - subtitleProvider:   `SubtitleProvider` used for search query.
    func subtitleDownloader(_ subtitleDownloader: SubtitleDownloader, willSearchSubtitlesFor searchCriteria: SearchCriteria, using subtitleProvider: SubtitleProvider)

    /// Called when `SubtitleDownloader` subtitle search is completed.
    ///
    /// - Parameters:
    ///   - subtitleDownloader: `SubtitleDownloader` which finished search.
    ///   - searchCriteria:     `SearchCriteria` which tells what subtitles have been searched.
    ///   - subtitleProvider:   `SubtitleProvider` used for search query.
    func subtitleDownloader(_ subtitleDownloader: SubtitleDownloader, didFindSubtitlesFor searchCriteria: SearchCriteria, using subtitleProvider: SubtitleProvider)

    /// Called when `SubtitleDownloader` is going to download subtitles.
    ///
    /// - Parameters:
    ///   - subtitleDownloader: `SubtitleDownloader` which begins downloading.
    ///   - searchCriteria:     `SearchCriteria` which tells what subtitles it will download.
    ///   - subtitleProvider:   `SubtitleProvider` used for download query.
    func subtitleDownloader(_ subtitleDownloader: SubtitleDownloader, willDownloadSubtitlesFor searchCriteria: SearchCriteria, using subtitleProvider: SubtitleProvider)

    /// Called when `SubtitleDownloader` subtitle download is completed.
    ///
    /// - Parameters:
    ///   - subtitleDownloader: `SubtitleDownloader` which finished download.
    ///   - searchCriteria:     `SearchCriteria` which tells what subtitles have been downloaded.
    ///   - subtitleProvider:   `SubtitleProvider` used for download query.
    func subtitleDownloader(_ subtitleDownloader: SubtitleDownloader, didDownloadSubtitlesFor searchCriteria: SearchCriteria, using subtitleProvider: SubtitleProvider)

    /// Called when `SubtitleDownloader` changes its status.
    ///
    /// - Parameter subtitleDownloader: `SubtitleDownloader` which changed its status.
    func subtitleDownloaderDidChangeStatus(_ subtitleDownloader: SubtitleDownloader)
}


/// Default, empty implementations of `SubtitleDownloaderDelegate`.
extension SubtitleDownloaderDelegate {
    func subtitleDownloader(_ subtitleDownloader: SubtitleDownloader, willSearchSubtitlesFor searchCriteria: SearchCriteria, using subtitleProvider: SubtitleProvider) { }
    func subtitleDownloader(_ subtitleDownloader: SubtitleDownloader, didFindSubtitlesFor searchCriteria: SearchCriteria, using subtitleProvider: SubtitleProvider) { }
    func subtitleDownloader(_ subtitleDownloader: SubtitleDownloader, willDownloadSubtitlesFor searchCriteria: SearchCriteria, using subtitleProvider: SubtitleProvider) { }
    func subtitleDownloader(_ subtitleDownloader: SubtitleDownloader, didDownloadSubtitlesFor searchCriteria: SearchCriteria, using subtitleProvider: SubtitleProvider) { }
    func subtitleDownloaderDidChangeStatus(_ subtitleDownloader: SubtitleDownloader) { }
}
