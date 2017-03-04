//
//  Created by Mateusz Karwat on 05/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Cocoa
import SwiftyBeaver

let log = SwiftyBeaver.self

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupSwiftyBeaver()
    }

    private func setupSwiftyBeaver() {
        let console = ConsoleDestination()

        let file = FileDestination()

        if let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
            let bundleName = Bundle.main.bundleIdentifier {
                let logURL = cachesURL
                    .appendingPathComponent(bundleName, isDirectory: true)
                    .appendingPathComponent("Napi.log")
                file.logFileURL = logURL
        }

        file.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $C$L$c - $M"
        _ = file.deleteLogFile()

        log.addDestination(console)
        log.addDestination(file)
    }
}
