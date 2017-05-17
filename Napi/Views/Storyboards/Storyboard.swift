//
//  Created by Mateusz Karwat on 29/04/2017.
//  Copyright © 2017 Mateusz Karwat. All rights reserved.
//

import AppKit

/// Enum which stores names of all storyboards in a project.
/// This enum allows for easy access and allocation of view controllers
/// and windows.
enum Storyboard: String {
    case Main
    case Preferences
    case Selection
    case Progress
}

extension Storyboard {

    /// Controllers in Interface Builder have an optional identifier within the storyboard. 
    /// That identifier is set from the inspector in Interface Builder. 
    /// The identifiers are optional, meaning that the developer only has to assign an identifier to a controller 
    /// if they want to be able to manually invoke this method from code.
    func instantiate<C: StoryboardIdentifiable>(_ viewController: C.Type, inBundle bundle: Bundle = .main) -> C {
        guard
            let vc = NSStoryboard(name: self.rawValue, bundle: bundle)
            .instantiateController(withIdentifier: C.storyboardIdentifier) as? C
        else {
            fatalError("Couldn't instantiate \(C.storyboardIdentifier) from \(self.rawValue)")
        }

        return vc
    }
}

// MARK: - StoryboardIdentifiable

/// Adds `storyboardIdentifier` property to generate a default
/// identifiers based on its type. In other words, if a view controller
/// has `MyViewController` class in Storyboard associated with,
/// it will also have a default identifier equal to "MyViewController".
protocol StoryboardIdentifiable {
    var storyboardIdentifier: String { get }
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable {
    var storyboardIdentifier: String {
        return String(reflecting: self).components(separatedBy: ".").dropFirst().joined(separator: ".")
    }

    static var storyboardIdentifier: String {
        return String(reflecting: self).components(separatedBy: ".").dropFirst().joined(separator: ".")
    }

    var description: String {
        return storyboardIdentifier
    }
}

// MARK: - Standard Extensions

extension NSViewController: StoryboardIdentifiable { }

extension NSWindowController: StoryboardIdentifiable { }
