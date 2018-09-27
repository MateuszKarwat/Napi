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
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable {
    static var storyboardIdentifier: String {
        return String(reflecting: self).components(separatedBy: ".").dropFirst().joined(separator: ".")
    }

}

// MARK: - Standard Extensions

extension NSViewController: StoryboardIdentifiable { }

extension NSWindowController: StoryboardIdentifiable { }

// MARK: - Enum Support

/// A set of computed properties which allow to create enums as `Storyboard` identifiers.
/// Let's say to created an enum as in extension as following:
///
///     extension ViewController {
///         enum Segue {
///             case presentDetails
///         }
///     }
///
/// Now, it's possible to compare `segue.identifier` to `Segue.presentDetails.segueIdentifier`.
/// No `Strings` are required to use it. Auto-generated idenfitier will be `"ViewController.Segue.presentDetails"`.
/// You can use this auto-generated identifier as an identifier in `Storyboard`.
extension StoryboardIdentifiable {
    var storyboardIdentifier: String {
        return String(reflecting: self).components(separatedBy: ".").dropFirst().joined(separator: ".")
    }

    /// Returns `NSUserInterfaceItemIdentifier` created based on `storyboardIdentifier`.
    var userInterfaceItemIdentifier: NSUserInterfaceItemIdentifier {
        return NSUserInterfaceItemIdentifier(self.storyboardIdentifier)
    }

    /// Returns `NSStoryboardSegue.Identifier` created based on `storyboardIdentifier`.
    var segueIdentifier: NSStoryboardSegue.Identifier {
        return self.storyboardIdentifier
    }
}
