//
//  Created by Mateusz Karwat on 18/12/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Describes how subtitles must be searched and downloaded by any subtitle provider.
protocol SubtitleProvider {

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

extension URLSession {

    /// Data task convenience method. This method creates tasks that
    /// bypass the normal deletage calls for response and data delivery.
    ///
    /// - Parameters:
    ///   - request:            An NSURLRequest object that provides the URL, cache policy,
    ///                         request type, body data or body stream, and so on.
    ///   - completionHandler:  The completion handler to call when the load request is complete.
    ///
    /// - Returns: The new session data task.
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, String.Encoding?) -> Void) -> URLSessionDataTask {
        return dataTask(with: request) { data, response, error in
            guard
                error == nil,
                let validData = data,
                let response = response as? HTTPURLResponse
            else {
                completionHandler(nil, nil)
                return
            }

            let emptyDataStatusCodes: Set<Int> = [204, 205]
            if emptyDataStatusCodes.contains(response.statusCode) {
                completionHandler(nil, nil)
                return
            }

            var convertedEncoding: String.Encoding? = nil

            if let encodingName = response.textEncodingName as CFString!, convertedEncoding == nil {
                convertedEncoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(
                    CFStringConvertIANACharSetNameToEncoding(encodingName))
                )
            }

            let actualEncoding = convertedEncoding ?? .isoLatin1

            completionHandler(validData, actualEncoding)
        }
    }
}
