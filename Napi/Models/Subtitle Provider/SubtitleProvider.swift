//
//  Created by Mateusz Karwat on 18/12/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Describes how subtitles must be searched and downloaded by any subtitle provider.
protocol SubtitleProvider: CustomStringConvertible {

    /// Name of a provider.
    var name: String { get }

    /// URL to a homepage.
    var homepage: URL { get }

    /// Request to a subtitle provider to find all subtitles that match specific `SearchCriteria`.
    ///
    /// - Parameters:
    ///   - searchCritera:     Rules which limit number of matched subtitles.
    ///   - completionHandler: Completion handler called when search is completed.
    func searchSubtitles(using searchCritera: SearchCriteria, completionHandler: @escaping ([SubtitleEntity]) -> Void)

    /// Tries to download subtitles which where found during search process.
    ///
    /// - Parameters:
    ///   - subtitleEntity:    Entity which has been returned as a search result.
    ///   - completionHandler: Completion handler called when download is completed.
    func download(_ subtitleEntity: SubtitleEntity, completionHandler: @escaping (SubtitleEntity?) -> Void)
}

// SubtitleProvider: Equatable
extension SubtitleProvider {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name && lhs.homepage == rhs.homepage
    }
}

// SubtitleProvider: CustomStringConvertible
extension SubtitleProvider {
    var description: String {
        return name
    }
}
