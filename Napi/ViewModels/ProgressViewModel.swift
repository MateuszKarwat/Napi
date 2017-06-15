//
//  Created by Mateusz Karwat on 14/05/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

protocol ProgressViewModelDelegate: class {

    /// Called when download is completed, correctly cancelled
    /// or something happens what makes a futher download impossible.
    func progressViewModelDidFinish(_ progressViewModel: ProgressViewModel)
}

final class ProgressViewModel: NSObject {
    weak var delegate: ProgressViewModelDelegate?

    fileprivate let engine: NapiEngine
    fileprivate let videoURLs: [URL]

    // MARK: - Lifecycle

    init(engine: NapiEngine, videoURLs: [URL]) {
        self.engine = engine
        self.videoURLs = videoURLs

        super.init()

        engine.delegate = self
    }

    // MARK: - Outputs

    fileprivate(set) dynamic var filename = ""
    fileprivate(set) dynamic var language = "-"
    fileprivate(set) dynamic var subtitleProvider = "-"
    fileprivate(set) dynamic var stateDescription = "Progress_Scanning".localized

    // MARK: - Inputs

    func viewDidAppear() {
        engine.downloadSubtitles(forVideoFilesAt: videoURLs)
    }

    func cancelButtonClicked() {
        engine.cancel()
    }
}

// MARK: - NapiEngineDelegate

extension ProgressViewModel: NapiEngineDelegate {
    func napiEngineDidChangeStatus(_ napiEngine: NapiEngine) {
        guard let statusInfo = napiEngine.statusInfo else {
            return
        }

        filename = FileInformation(url: statusInfo.videoURL)?.name ?? statusInfo.videoURL.absoluteString
        language = statusInfo.language.currentLocaleName ?? statusInfo.language.isoCode
        subtitleProvider = statusInfo.subtitleProviderName
        stateDescription = napiEngine.status.localizedDescription
    }

    func napiEngine(_ napiEngine: NapiEngine, didProvideSubtitlesAt url: URL) {
        if Preferences[.postNotifications] {
            NSUserNotificationCenter.default.postNotification(forFileAt: url)
        }
    }

    func napiEngineDidFinish(_ napiEngine: NapiEngine) {
        delegate?.progressViewModelDidFinish(self)
    }
}

extension NapiEngine.Status {

    /// Returns a localized description for every state NapiEngine may have.
    fileprivate var localizedDescription: String {
        switch self {
        case .idle:
            return "Progress_Waiting".localized
        case .searching:
            return "Progress_Searching".localized
        case .downloading:
            return "Progress_Downloading".localized
        case .processing:
            return "Progress_Processing".localized
        case .moving:
            return "Progress_Moving".localized
        case .canceling:
            return "Progress_Canceling".localized
        }
    }
}
