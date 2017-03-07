//
//  Created by Mateusz Karwat on 05/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: - Handle Files and Directories

    var queuedPaths = [String]()

    func application(_ sender: NSApplication, openFiles filenames: [String]) {

        // I saw cases in which dragging a bunch of files onto the app
        // actually called application:openFiles several times, resulting
        // in more than one window, with the dragged files split amongst them.
        // This is lame. So we queue them up and open them all at once later.
        queuedPaths += filenames
        perform(#selector(processQueuedPaths), with: nil, afterDelay: 0.25)

        NSApp.reply(toOpenOrPrint: .success)
    }

    func processQueuedPaths() {
        guard queuedPaths.isNotEmpty else {
            return
        }

        var videoURLs = [URL]()

        for path in queuedPaths {
            let url = URL(fileURLWithPath: path)

            if url.isDirectory {
                videoURLs += DirectoryScanner.videoFilesInDirectory(at: url)
            } else if url.isVideo {
                videoURLs.append(url)
            }
        }

        // TODO: Do something with videoURLs.
        dump(videoURLs)

        queuedPaths = []
    }
}
