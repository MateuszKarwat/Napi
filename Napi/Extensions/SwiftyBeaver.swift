//
//  SwiftyBeaver.swift
//  Napi
//
//  Created by Mateusz Karwat on 28/09/2018.
//  Copyright © 2018 Mateusz Karwat. All rights reserved.
//

import AppKit
import SwiftyBeaver

extension SwiftyBeaver {
    static func configure() {
        let file = FileDestination()
        let console = ConsoleDestination()

        if let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
            let bundleName = Bundle.main.bundleIdentifier {
            let logURL = cachesURL
                .appendingPathComponent(bundleName, isDirectory: true)
                .appendingPathComponent("Napi.log")
            file.logFileURL = logURL

            if let fileInformation = FileInformation(url: logURL), fileInformation.size > 10_000_000 {
                _ = file.deleteLogFile()
            }
        }

        file.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $C$L$c\t$N - $M"
        console.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $C$L$c \t$N - $M"

        log.addDestination(file)
        log.addDestination(console)
    }

}
