//
//  Created by Mateusz Karwat on 18/12/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

struct Napisy24: SubtitleProvider {
    let name = "Napisy24"
    let homepage = URL(string: "http://napisy24.pl")!

    func searchSubtitles(using searchCritera: SearchCriteria, completionHandler: @escaping ([SubtitleEntity]) -> Void) {
        guard let searchRequest = searchRequest(with: searchCritera) else {
            completionHandler([])
            return
        }

        let dataTask = URLSession.shared.dataTask(with: searchRequest) { data, encoding in
            guard
                let data = data,
                let encoding = encoding,
                let stringResponse = String(data: data, encoding: encoding),
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
                let onlySubtitles = content.filter { ["txt", "srt"].contains($0.pathExtension) }

                if let subtitle = onlySubtitles.first {
                    let extractedSubtitlePath = subtitleEntity.temporaryPathWithoutFormatExtension
                        .appendingPathExtension(SubtitleEntity.Format.text.pathExtension)

                    try fileManager.moveItem(at: subtitle, to: extractedSubtitlePath)
                    try fileManager.removeItem(at: extractedArchive)
                    try fileManager.removeItem(at: subtitleEntity.url)
                    
                    downloadedSubtitleEntity = subtitleEntity
                    downloadedSubtitleEntity?.format = .text
                    downloadedSubtitleEntity?.url = extractedSubtitlePath
                } else {
                    return
                }
            } catch {
                return
            }
        }

        return
    }

    private func subtitleEntity(from stringResponse: String, in language: Language) -> SubtitleEntity? {
        guard
            stringResponse.substring(to: 4) == "OK-2",
            let archiveStartIndex = stringResponse.range(of: "||")?.upperBound
        else {
            return nil
        }

        let subtitleEntity = SubtitleEntity(language: language, format: .archive)
        let archiveString = stringResponse.substring(from: archiveStartIndex)
        let archiveData = archiveString.data(using: .isoLatin1)

        do {
            TemporaryDirectoryManager.default.createTemporaryDirectory()

            try archiveData?.write(to: subtitleEntity.url)
        } catch {
            return nil
        }

        return subtitleEntity
    }

    private func searchRequest(with searchCriteria: SearchCriteria) -> URLRequest? {
        guard
            let informationProvider = FileInformationProvider(url: searchCriteria.fileURL),
            let checksum = informationProvider.checksum,
            let md5 = informationProvider.md5(chunkSize: 10 * 1024 * 1024)
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
        parameters["fn"] = informationProvider.name
        parameters["nl"] = searchCriteria.language.isoCode
        parameters["fs"] = String(informationProvider.size)
        
        var urlRequest = URLRequest(url: baseURL)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = parameters.httpBodyFormat.data(using: .utf8)
        
        return urlRequest
    }
}
