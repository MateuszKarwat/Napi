//
//  Created by Mateusz Karwat on 21/01/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

final class OpenSubtitles: SubtitleProvider {

    /// Token required for API requests.
    var token: String?

    // MARK: - SubtitleProvider

    let name = "OpenSubtitles"
    let homepage = URL(string: "https://www.opensubtitles.org")!

    func searchSubtitles(using searchCritera: SearchCriteria, completionHandler: @escaping ([SubtitleEntity]) -> Void) {
        requestToken {
            guard let searchRequest = self.searchRequest(with: searchCritera) else {
                completionHandler([])
                return
            }

            let dataTask = URLSession.shared.dataTask(with: searchRequest) { data, encoding in
                guard
                    let data = data,
                    let encoding = encoding,
                    let stringResponse = String(data: data, encoding: encoding)
                    else {
                        completionHandler([])
                        return
                }

                completionHandler(self.subtitleEntities(from: stringResponse))
            }

            dataTask.resume()
        }
    }

    func download(_ subtitleEntity: SubtitleEntity, completionHandler: @escaping (SubtitleEntity?) -> Void) {
        guard
            subtitleEntity.format == .remote,
            !subtitleEntity.url.isFileURL
        else {
            completionHandler(nil)
            return
        }

        let directoryManager = TemporaryDirectoryManager.default
        directoryManager.createTemporaryDirectory()

        let downloadRequest = URLRequest(url: subtitleEntity.url)
        let downloadTask = URLSession.shared.downloadTask(with: downloadRequest) { downloadLocation, _, error in
            guard
                error == nil,
                let downloadLocation = downloadLocation
            else {
                completionHandler(nil)
                return
            }

            let extractedArchive = subtitleEntity.temporaryPathWithoutFormatExtension
            Unziper.unzipFile(at: downloadLocation, to: extractedArchive, overwrite: true)

            if extractedArchive.exists && extractedArchive.isDirectory {
                let fileManager = FileManager.default

                do {
                    let content = try fileManager.contentsOfDirectory(at: extractedArchive, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                    let onlySubtitles = content.filter { SupportedSubtitleFormat.allFileExtensions.contains($0.pathExtension) }

                    if let subtitle = onlySubtitles.first {
                        let extractedSubtitlePath = subtitleEntity.temporaryPathWithoutFormatExtension
                            .appendingPathExtension(SubtitleEntity.Format.text.pathExtension)

                        try fileManager.moveItem(at: subtitle, to: extractedSubtitlePath)
                        try fileManager.removeItem(at: extractedArchive)
                        try fileManager.removeItem(at: downloadLocation)

                        var downloadedSubtitleEntity = subtitleEntity
                        downloadedSubtitleEntity.format = .text
                        downloadedSubtitleEntity.url = extractedSubtitlePath

                        completionHandler(downloadedSubtitleEntity)
                    } else {
                        completionHandler(nil)
                        return
                    }
                } catch {
                    completionHandler(nil)
                    return
                }
            }
        }

        downloadTask.resume()
    }

    // MARK: - Lifecycle

    deinit {
        if token != nil {
            unregisterToken()
        }
    }

    // MARK: - Responses

    private func subtitleEntities(from xmlResponse: String) -> [SubtitleEntity] {
        var subtitleEntities = [SubtitleEntity]()

        do {
            let xml = try XMLDocument(xmlString: xmlResponse, options: 0)
            let matchResults = try xml.nodes(forXPath: "//struct//data//struct")

            matchResults.forEach { result in
                guard
                    let languageCode = result.rpcValue(forParameterWithName: "ISO639"),
                    let stringURL = result.rpcValue(forParameterWithName: "ZipDownloadLink"),
                    var downloadURL = URL(string: stringURL)
                else {
                    return
                }

                if let downloadPathIndex = downloadURL.pathComponents.index(of: "download") {
                    downloadURL = downloadURL.appendingPathComponent("subencoding-utf8", at: downloadPathIndex + 1)
                }

                let language = Language(isoCode: languageCode)
                let subtitleEntity = SubtitleEntity(language: language, format: .remote, url: downloadURL)

                subtitleEntities.append(subtitleEntity)
            }
        } catch {
            return []
        }

        return subtitleEntities
    }

    // MARK: - Requests

    private func searchRequest(with searchCriteria: SearchCriteria) -> URLRequest? {
        guard
            let fileInformation = FileInformation(url: searchCriteria.fileURL),
            let md5 = fileInformation.md5(chunkSize: 10 * 1024 * 1024)
        else {
            return nil
        }

        var parameters = [String: String]()
        parameters["sublanguageid"] = searchCriteria.language.isoCodeLong
        parameters["moviehash"] = md5
        parameters["moviebytesize"] = String(fileInformation.size)

        return urlRequest(with: searchSubtitlesXML(parameters: parameters))
    }

    private func requestToken(completionHandler: @escaping () -> Void) {
        guard token == nil else {
            completionHandler()
            return
        }

        let request = urlRequest(with: loginXML())

        let dataTask = URLSession.shared.dataTask(with: request) { data, encoding in
            guard
                let data = data,
                let encoding = encoding,
                let stringResponse = String(data: data, encoding: encoding)
            else {
                completionHandler()
                return
            }

            do {
                let xmlDocument = try XMLDocument(xmlString: stringResponse, options: 0)
                let structNodes = try xmlDocument.nodes(forXPath: "//struct")

                self.token = structNodes.first?.rpcValue(forParameterWithName: "token")
                completionHandler()
            } catch {
                completionHandler()
            }
        }

        dataTask.resume()
    }

    private func unregisterToken() {
        if let token = token {
            let request = urlRequest(with: logoutXML(withToken: token))
            let dataTask = URLSession.shared.dataTask(with: request)

            dataTask.resume()
        }
    }

    private func urlRequest(with xmlDocument: XMLRPCDocument) -> URLRequest {
        var urlRequest = URLRequest.defaultXMLRPCRequest
        urlRequest.httpBody = xmlDocument.xmlData

        return urlRequest
    }

    // MARK: - XML-RPC Documents

    private func searchSubtitlesXML(parameters: [String: String]) -> XMLRPCDocument {
        let xmlDocument = XMLRPCDocument(methodName: "SearchSubtitles")

        if let params = xmlDocument.parameters {
            params.addChild(atKeyPath: "value.string", value: token ?? "")

            let membersStruct = params.addChild(atKeyPath: "param.value.array.data.value.struct")

            for (keyName, value) in parameters {
                let member = XMLElement(name: "member")
                member.addChild(atKeyPath: "name", value: keyName)
                member.addChild(atKeyPath: "value.string", value: value)

                membersStruct.addChild(member)
            }
        }

        return xmlDocument
    }

    private func loginXML() -> XMLRPCDocument {
        let xmlDocument = XMLRPCDocument(methodName: "LogIn")

        if let parameters = xmlDocument.parameters {
            parameters.addChild(atKeyPath: "param.value.string")
            parameters.addChild(atKeyPath: "param.value.string")
            parameters.addChild(atKeyPath: "param.value.string")
            parameters.addChild(atKeyPath: "param.value.string", value: "QNapi v0.2.2")
        }

        return xmlDocument
    }

    private func logoutXML(withToken token: String) -> XMLRPCDocument {
        let xmlDocument = XMLRPCDocument(methodName: "LogOut")

        if let parameters = xmlDocument.parameters {
            parameters.addChild(atKeyPath: "param.value.string", value: token)
        }

        return xmlDocument
    }
}

fileprivate extension URLRequest {

    /// Returns `URLRequest` for `OpenSubtitles` with default header.
    static var defaultXMLRPCRequest: URLRequest {
        var request = URLRequest(url: URL(string: "http://api.opensubtitles.org:80/xml-rpc")!)
        request.httpMethod = "POST"
        request.setValue("text/xml", forHTTPHeaderField: "Content-Type")
        request.setValue("text/xml", forHTTPHeaderField: "Accept")
        request.setValue(UserDefaults.standard.object(forKey: "UserAgent") as? String, forHTTPHeaderField: "User-Agent")
        
        return request
    }
}
