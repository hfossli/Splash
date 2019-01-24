/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

#if os(macOS)

import Foundation
import Splash

extension String: Error {}

struct CLI {

    struct Options {
        var code: String? = nil
        var outputURL: URL? = nil
        var padding: Double = 20.0
        var width: Double? = nil
        var fontPath: String? = nil
        var fontSize: Double = 20.0

        var font: Font {
            if let fontPath = fontPath {
                return Font(path: fontPath, size: fontSize)
            }
            return Font(size: fontSize)
        }
    }

    struct ANSIColors {
        static let clear = "\u{001B}[0m"
        static let red = "\u{001B}[38;5;160m"
        static let green = "\u{001B}[0;32m"
    }

    static func usage(error: Error) -> Never {
        let scriptLocation = CommandLine.arguments.first ?? "unknown"
        let defaults = Options()
        print("""

            \(ANSIColors.red)Script \(scriptLocation) failed.\(ANSIColors.clear)
            
            \(ANSIColors.red)👉 \(error)\(ANSIColors.clear)

            Usage: \(scriptLocation)
                --output        Path to where the image should be saved. Default: \(String(describing: defaults.outputURL))
                --width         Set a fixed width. Default: \(String(describing: defaults.width))
                --font          Path to font. Default: \(String(describing: defaults.fontPath))
                --fontSize      Size of font. Default: \(String(describing: defaults.fontSize))
                --padding       Padding around text. Default: \(String(describing: defaults.padding))

            """)
        exit(1)
    }

    static func makeOptions() throws -> Options {
        var options = Options()
        var arguments = CommandLine.arguments
        arguments.removeFirst()
        while arguments.isEmpty == false {
            let argument = arguments.removeFirst()
            switch argument {
                case "--width":
                    guard !arguments.isEmpty, let value = Double(arguments.removeFirst()) else {
                        usage(error: "Bad value passed to \(argument) option")
                    }
                    options.width = value
                case "--output", "-o":
                    guard !argument.isEmpty else {
                        usage(error: "Bad value passed to \(argument) option")
                    }
                    options.outputURL = URL(fileURLWithPath: (arguments.removeFirst() as NSString).expandingTildeInPath)
                case "--padding", "-p":
                    guard !arguments.isEmpty, let value = Double(arguments.removeFirst()) else {
                        usage(error: "Bad value passed to \(argument) option")
                    }
                    options.padding = value
                case "--fontSize", "-s":
                    guard !arguments.isEmpty, let value = Double(arguments.removeFirst()) else {
                        usage(error: "Bad value passed to \(argument) option")
                    }
                    options.fontSize = value
                case "--font", "-f":
                    guard !arguments.isEmpty else {
                        usage(error: "Bad value passed to \(argument) option")
                    }
                    options.fontPath = (arguments.removeFirst() as NSString).expandingTildeInPath as String
                default:
                    if options.code == nil {
                        options.code = argument
                    } else if options.outputURL == nil {
                        options.outputURL = URL(fileURLWithPath: (arguments.removeFirst() as NSString).expandingTildeInPath)
                    } else {
                        usage(error: "Too many arguments given without argument specifiers.\nCan't understand \"\(argument)\".")
                    }
            }
        }
        return options
    }    
}

#endif
