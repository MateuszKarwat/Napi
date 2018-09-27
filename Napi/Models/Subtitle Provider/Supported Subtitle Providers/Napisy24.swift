//
//  Created by Mateusz Karwat on 18/12/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

struct Napisy24: SubtitleProvider {
    let name = "Napisy24"
    let homepage = URL(string: "http://napisy24.pl")!

    func searchSubtitles(using searchCritera: SearchCriteria, completionHandler: @escaping ([SubtitleEntity]) -> Void) {
        log.info("Sending search request.")

        guard let searchRequest = searchRequest(with: searchCritera) else {
            log.warning("Search request couldn't be created.")
            completionHandler([])
            return
        }

        let dataTask = URLSession.shared.dataTask(with: searchRequest) { data, encoding in
            log.info("Search response received.")

            guard
                let data = data,
                let encoding = encoding,
                let stringResponse = String(data: data, encoding: encoding) ?? String(data: data, encoding: .isoLatin1),
                let subtitleEntity = self.subtitleEntity(from: stringResponse, in: searchCritera.language)
            else {
                completionHandler([])
                return
            }

            completionHandler([subtitleEntity])
        }

        dataTask.resume()
    }

    func download(_ subtitleEntity: SubtitleEntity, completionHandler: @escaping (SubtitleEntity?) -> Void) {
        log.info("Downloading subtitles.")

        var downloadedSubtitleEntity: SubtitleEntity? = nil

        defer {
            completionHandler(downloadedSubtitleEntity)
        }

        guard subtitleEntity.format == .archive else { return }

        let directoryManager = TemporaryDirectoryManager.default
        directoryManager.createTemporaryDirectory()

        let extractedArchive = subtitleEntity.temporaryPathWithoutFormatExtension
        Unziper.unzipFile(at: subtitleEntity.url, to: extractedArchive, overwrite: true)

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
                    try fileManager.removeItem(at: subtitleEntity.url)
                    
                    downloadedSubtitleEntity = subtitleEntity
                    downloadedSubtitleEntity?.format = .text
                    downloadedSubtitleEntity?.url = extractedSubtitlePath

                    log.info("Subtitles downloaded.")
                } else {
                    return
                }
            } catch let error {
                log.error(error.localizedDescription)
                return
            }
        }

        return
    }

    private func subtitleEntity(from stringResponse: String, in language: Language) -> SubtitleEntity? {
        log.verbose("Parsing search response.")

        guard
            stringResponse.substring(to: 4) == "OK-2",
            let archiveStartIndex = stringResponse.range(of: "||")?.upperBound
        else {
            log.verbose("Subtitles has not been found.")
            return nil
        }

        let subtitleEntity = SubtitleEntity(language: language, format: .archive)
        let archiveString = stringResponse[archiveStartIndex...]
        let archiveData = archiveString.data(using: .isoLatin1)

        do {
            TemporaryDirectoryManager.default.createTemporaryDirectory()

            try archiveData?.write(to: subtitleEntity.url)

            log.verbose("Subtitles has been found.")
        } catch let error {
            log.error(error.localizedDescription)
            return nil
        }

        return subtitleEntity
    }

    private func searchRequest(with searchCriteria: SearchCriteria) -> URLRequest? {
        guard
            searchCriteria.language.isoCode == "pl", // Napisy24 returns only subtitles in Polish.
            let fileInformation = FileInformation(url: searchCriteria.fileURL),
            let checksum = fileInformation.checksum,
            let md5 = fileInformation.md5(chunkSize: 10 * 1024 * 1024)
        else {
            return nil
        }

        let baseURL = URL(string: "http://napisy24.pl/run/CheckSubAgent.php")!

        var parameters = [String: String]()
        parameters["postAction"] = "CheckSub"
        parameters["ua"] = "tantalosus"
        parameters["ap"] = "susolatnat"
        parameters["fh"] = checksum
        parameters["md"] = md5
        parameters["fn"] = fileInformation.name
        parameters["nl"] = searchCriteria.language.isoCode
        parameters["fs"] = String(fileInformation.size)
        
        var urlRequest = URLRequest(url: baseURL)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = parameters.httpBodyFormat.data(using: .utf8)
        
        return urlRequest
    }
}
