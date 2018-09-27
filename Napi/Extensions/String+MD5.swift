//
//  Created by Mateusz Karwat on 28/08/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

extension String {

    /// Creates 128-bit hash value.
    var md5: String {
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        let md5Buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)

        CC_MD5((self as NSString).utf8String, CC_LONG((self as NSString).length), md5Buffer)

        var output = ""
        for i in 0 ..< digestLength {
            output += String(format: "%02x", md5Buffer[i])
        }

        md5Buffer.deallocate()

        return output
    }
}
