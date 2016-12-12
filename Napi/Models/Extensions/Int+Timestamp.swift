//
//  Created by Mateusz Karwat on 24/07/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

// Extension to make operations on `Timestamps` very clear and easy.
extension Int {
    var milliseconds: Timestamp {
        return Timestamp(value: self, unit: .milliseconds)
    }

    var deciseconds: Timestamp {
        return Timestamp(value: self, unit: .deciseconds)
    }

    var seconds: Timestamp {
        return Timestamp(value: self, unit: .seconds)
    }

    var minutes: Timestamp {
        return Timestamp(value: self, unit: .minutes)
    }

    var hours: Timestamp {
        return Timestamp(value: self, unit: .hours)
    }

    func frames(frameRate: Double) -> Timestamp {
        return Timestamp(value: self, unit: .frames(frameRate: frameRate))
    }
}

extension Int {

    /// Converts an `Int` into  a `String` and adds
    /// specified number of leadins zeros as a prefix.
    func toString(leadingZeros: Int) -> String {
        return String(format: "%0\(leadingZeros)d", self)
    }
}
