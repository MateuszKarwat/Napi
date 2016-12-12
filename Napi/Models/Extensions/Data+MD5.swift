//
//  Created by Mateusz Karwat on 28/08/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

extension Data {

    /// Creates 128-bit hash value.
    var md5: String {
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        let md5Buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)

        withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
            CC_MD5(bytes, CC_LONG(count), md5Buffer)
        }

        var output = ""
        for i in 0 ..< digestLength {
            output += String(format: "%02x", md5Buffer[i])
        }

        return output
    }
}
