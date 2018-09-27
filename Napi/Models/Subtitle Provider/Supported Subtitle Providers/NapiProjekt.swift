//
//  Created by Mateusz Karwat on 14/01/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

struct NapiProjekt: SubtitleProvider {
    let name = "NapiProjekt"
    let homepage = URL(string: "http://www.napiprojekt.pl")!

    func searchSubtitles(using searchCritera: SearchCriteria, completionHandler: @escaping ([SubtitleEntity]) -> Void) {
        log.info("Sending search request.")

        guard let searchRequest = searchRequest(with: searchCritera) else {
            log.warning("Search request couldn't be created.")
            completionHandler([])
            return
        }

        let dataTask = URLSession.shared.dataTask(with: searchRequest) { data, _ in
            log.info("Search response received.")

            guard
                let data = data,
                let stringResponse = String(data: data, encoding: .windowsCP1250),
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

        guard
            subtitleEntity.format == .text,
            subtitleEntity.url.isFile,
            subtitleEntity.url.exists
        else {
            log.error("Download failed.")
            completionHandler(nil)
            return
        }

        log.info("Subtitles downloaded.")
        completionHandler(subtitleEntity)
    }

    private func subtitleEntity(from stringResponse: String, in language: Language) -> SubtitleEntity? {
        log.verbose("Parsing search response.")

        if stringResponse == "NPc0" {
            log.verbose("Subtitles has not been found.")
            return nil
        }

        let directoryManager = TemporaryDirectoryManager.default
        directoryManager.createTemporaryDirectory()

        let subtitleEntity = SubtitleEntity(language: language, format: .text)

        do {
            try stringResponse.write(to: subtitleEntity.url, atomically: true, encoding: .windowsCP1250)

            log.verbose("Subtitles has been found.")
            return subtitleEntity
        } catch let error {
            log.error(error.localizedDescription)
            return nil
        }
    }

    private func searchRequest(with searchCriteria: SearchCriteria) -> URLRequest? {
        guard
            let fileInformation = FileInformation(url: searchCriteria.fileURL),
            let md5 = fileInformation.md5(chunkSize: 10 * 1024 * 1024),
            let md5Hash = mysteriousHash(of: md5)
        else {
            return nil
        }

        var parameters = [String: String]()
        parameters["l"] = searchCriteria.language.isoCode.uppercased()
        parameters["f"] = md5
        parameters["t"] = md5Hash
        parameters["v"] = "pynapi"
        parameters["kolejka"] = "false"
        parameters["nick"] = ""
        parameters["pass"] = ""
        parameters["napios"] = "macOS"

        // NapiProject requires ISO-639-2 for English.
        if parameters["l"] == "EN" {
            parameters["l"] = "ENG"
        }

        guard let baseURL = URL(string: "http://napiprojekt.pl/unit_napisy/dl.php?".appending(parameters.httpBodyFormat)) else {
            return nil
        }

        return URLRequest(url: baseURL)
    }

    private func mysteriousHash(of md5Hash: String) -> String? {
        if md5Hash.count != 32 {
            return nil
        }

        let idx = [0xe, 0x3, 0x6, 0x8, 0x2]
        let mul = [2, 2, 5, 4, 3]
        let add = [0x0, 0xd, 0x10, 0xb, 0x5]

        var t = 0
        var tmp: UInt32 = 0
        var v: UInt32 = 0

        var generatedHash = ""

        for i in 0 ..< 5 {
            var scanner = Scanner(string: String(format: "%c", (md5Hash as NSString).character(at: idx[i])))
            scanner.scanHexInt32(&tmp)

            t = add[i] + Int(tmp)

            var subString = ""

            if (t > 30) {
                subString = md5Hash.substring(from: t)
            } else {
                let characterIndex = md5Hash.index(md5Hash.startIndex, offsetBy: t)
                subString = String(md5Hash[characterIndex ..< md5Hash.index(characterIndex, offsetBy: 2)])
            }

            scanner = Scanner(string: subString)
            scanner.scanHexInt32(&v)

            let hexResult = String(format: "%x", Int(v) * mul[i])
            let lastHexCharacter = hexResult.last ?? Character("")
            generatedHash.append(lastHexCharacter)
        }
        
        
        return generatedHash.trimmingCharacters(in: .newlines)
    }
}
