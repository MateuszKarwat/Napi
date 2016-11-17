//
//  Disctionary+HTTPBodyFormat.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/09/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

extension Dictionary where Key: ExpressibleByStringLiteral, Value: ExpressibleByStringLiteral {

    /// Returns a string in a HTTP Body Format.
    /// `Keys` of the dictionary are parameter names
    /// and `Values` are parameter values.
    ///
    /// For example:
    ///
    ///     let dict = ["parameterOne": "valueOne", "parameterTwo": "valueTwo"]
    ///     print(dict.httpBodyFormat)
    ///     // Prints "parameterOne=valueOne&parameterTwo=valueTwo".
    var httpBodyFormat: String {
        let joinedParameters = self.map { return "\($0.key)=\($0.value)" }.joined(separator: "&")
        return joinedParameters.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? joinedParameters
    }
}
