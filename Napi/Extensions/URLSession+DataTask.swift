//
//  Created by Mateusz Karwat on 26/01/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

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

            if let encodingName = response.textEncodingName, convertedEncoding == nil {
                convertedEncoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(
                    CFStringConvertIANACharSetNameToEncoding(encodingName as CFString))
                )
            }

            let actualEncoding = convertedEncoding ?? .isoLatin1

            completionHandler(validData, actualEncoding)
        }
    }
}
