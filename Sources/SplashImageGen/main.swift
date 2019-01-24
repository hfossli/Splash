/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

#if os(macOS)

import Cocoa
import Splash

do {
    let options = try CLI.makeOptions()
    let theme = Theme.xcode(withFont: options.font)
    let outputFormat = AttributedStringOutputFormat(theme: theme)
    let highlighter = SyntaxHighlighter(format: outputFormat)
    let string = highlighter.highlight(options.code ?? "")
    var stringSize = string.size()

    if let width = options.width {
        stringSize.width = CGFloat(width)
    }
    if let minimumWidth = options.minimumWidth {
        stringSize.width = max(CGFloat(minimumWidth), stringSize.width)
    }

    let contextRect = CGRect(
        x: 0,
        y: 0,
        width: stringSize.width + CGFloat(options.padding) * 2,
        height: stringSize.height + CGFloat(options.padding) * 2
    )

    let context = NSGraphicsContext(size: contextRect.size)
    NSGraphicsContext.current = context

    context.fill(with: theme.backgroundColor, in: contextRect)

    string.draw(in: CGRect(
        x: CGFloat(options.padding),
        y: CGFloat(options.padding),
        width: stringSize.width,
        height: stringSize.height
    ))

    let image = context.cgContext.makeImage()!
    if let outputURL = options.outputURL {
        image.write(to: outputURL)
    } else {
        image.copyToPasteboard()
    }
} catch {
    print(CLI.ANSIColors.red, "Script failed due to error:", CLI.ANSIColors.clear, "\n", error)
    exit(1)
}

#else
print("😞 SplashImageGen currently only supports macOS")
#endif
