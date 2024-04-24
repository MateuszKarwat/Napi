//
//  Created by Mateusz Karwat on 28/08/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation
import CryptoKit

extension Data {

    /// Creates 128-bit hash value.
    var md5: String {
        Insecure.MD5.hash(data: self)
            .map { String(format: "%02x", $0) }
            .joined()
    }
}
