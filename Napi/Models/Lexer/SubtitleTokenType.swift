//
//  Created by Mateusz Karwat on 09/07/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Most common tags used in subtitle formats.
///
/// - Note: There are few missing tags, for example:
///   *position on a screen*. Those are not so popular though.
///   Implemenation of them is not important, but can be done
///   in the future.
enum SubtitleTokenType: String {
    case boldStart, boldEnd
    case italicStart, italicEnd
    case underlineStart, underlineEnd
    case fontColorStart, fontColorEnd
    case whitespace
    case newLine
    case word
    case unknownCharacter
}

extension Lexer {
    
    /// Set of rules which describe tokens possible to find in most common subtitle formats.
    class var defaultSubtitleRules: [(String, SubtitleTokenType)] {
        return [
            // Very straight forward definition of most common formatters: bold, italic, underline.
            // There are 3 most common tags for each formatter.
            // All of them should exactly match given format.
            ("\\{y:b\\}|\\{b\\}|<b>", .boldStart), ("\\{/y:b\\}|\\{/b\\}|</b>", .boldEnd),
            ("\\{y:i\\}|\\{i\\}|<i>", .italicStart), ("\\{/y:i\\}|\\{/i\\}|</i>", .italicEnd),
            ("\\{y:u\\}|\\{u\\}|<u>", .underlineStart), ("\\{/y:u\\}|\\{/u\\}|</u>", .underlineEnd),

            // Font color can be specified in a few ways. Some examples are:
            // {c:#RRGGBB}, {c:$RED}, <font color="$RRGGBB">, <font color="#RED">
            // There is one capuring group to capture a color name.
            ("(?:\\{c:|<font color=\")([$#]?\\w*)(?:\\}|\">)", .fontColorStart),

            // Font color tag can be specified in one of two ways: '{/c}' or '</font>'.
            ("\\{/c\\}|</font>", .fontColorEnd),

            // Line separator can be be specified in one of there ways: '|' or '\r\n' or '\n'.
            ("\\||\\r\\n|\\n", .newLine),

            // Any character like space or tab.
            ("\\s", .whitespace),

            // Any word character.
            ("\\w+", .word),

            // Sometimes '/' is used to mark whole line as italic.
            ("/", .italicStart),

            // If nothing specified before matches given string, it's an unknown character.
            (".", .unknownCharacter),
        ]
    }
}
