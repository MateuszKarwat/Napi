//
//  Created by Mateusz Karwat on 21/01/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import Foundation

/// `XMLDocument` with default structure in `XML-RPC` format.
class XMLRPCDocument: XMLDocument {

    /// Returns a new instalce of `XMLRPCDocument`.
    ///
    /// - Parameter methodName: Name of method of XML-RPC request.
    init(methodName: String) {
        super.init()

        characterEncoding = "utf-8"

        let methodCall = XMLElement(name: "methodCall")
        let methodName = XMLElement(name: "methodName", stringValue: methodName)
        let params = XMLElement(name: "params")

        setRootElement(methodCall)
        rootElement()?.addChild(methodName)
        rootElement()?.addChild(params)
    }

    /// Returns an element which stores all request parameters.
    var parameters: XMLElement? {
        return rootElement()?.elements(forName: "params").first
    }
}

extension XMLElement {

    /// Add child XML elements to `self`.
    ///
    /// - Parameters:
    ///   - keyPath:    A `String` with name of child elements, separated by `.` character.
    ///   - value:      Child XML element value (defaults to `nil`).
    ///
    /// - Returns: Reference to last element at `keyPath`.
    @discardableResult
    func addChild(atKeyPath keyPath: String, value: String? = nil) -> XMLElement {
        let keys = keyPath.components(separatedBy: ".")

        var currentElement = self

        keys.forEach { key in
            let newElement = XMLElement(name: key)
            currentElement.addChild(newElement)
            currentElement = newElement
        }

        if let value = value {
            currentElement.setStringValue(value, resolvingEntities: false)
        }

        return currentElement
    }
}

extension XMLNode {

    /// Returns value for a node with name "value",
    /// which is a sibling of a node with string value equal to specified name.
    func rpcValue(forParameterWithName name: String) -> String? {
        do {
            let matchedParameters = try self.nodes(forXPath: ".//*[text()='\(name)']")

            return matchedParameters.first?.nextSibling?.stringValue
        } catch {
            return nil
        }
    }
}
