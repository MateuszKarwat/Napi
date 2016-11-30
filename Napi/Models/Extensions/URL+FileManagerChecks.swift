//
//  Created by Mateusz Karwat on 30/11/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

extension URL {

    /// Checks if a URL points to a directory.
    var isDirectory: Bool {
        var isDirectoryFlag: ObjCBool = false
        FileManager.default.fileExists(atPath: self.path, isDirectory: &isDirectoryFlag)
        return isDirectoryFlag.boolValue
    }

    /// Checks if a URL points to a file.
    var isFile: Bool {
        return !self.isDirectory
    }

    /// Checks if a URL points either to a file or directory which actually exists.
    var exists: Bool {
        return FileManager.default.fileExists(atPath: self.path)
    }
}
