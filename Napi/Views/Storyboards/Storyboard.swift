//
//  Created by Mateusz Karwat on 29/04/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import AppKit

enum Storyboard: String {
    case Main
    case Preferences
    case Selection
    case Progress

    func instantiate<C: StoryboardIdentifiable>(_ viewController: C.Type, inBundle bundle: Bundle = .main) -> C {
        guard let vc = NSStoryboard(name: self.rawValue, bundle: bundle)
            .instantiateController(withIdentifier: C.storyboardIdentifier) as? C
        else {
            fatalError("Couldn't instantiate \(C.storyboardIdentifier) from \(self.rawValue)")
        }

        return vc
    }
}

// MARK: - StoryboardIdentifiable

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
    var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable {
    static var storyboardIdentifier: String {
        return String(reflecting: self).components(separatedBy: ".").dropFirst().joined(separator: ".")
    }

    var storyboardIdentifier: String {
        return String(reflecting: self).components(separatedBy: ".").dropFirst().joined(separator: ".")
    }

    var description: String {
        return storyboardIdentifier
    }
}

// MARK: - Standard Extensions

extension NSViewController: StoryboardIdentifiable {

}

extension NSWindowController: StoryboardIdentifiable {
    
}
