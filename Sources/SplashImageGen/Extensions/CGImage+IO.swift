/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

#if os(macOS)

import Foundation
import AppKit

extension CGImage {
    func write(to url: URL) {
        let destination = CGImageDestinationCreateWithURL(url as CFURL, kUTTypePNG, 1, nil)!
        CGImageDestinationAddImage(destination, self, nil)
        CGImageDestinationFinalize(destination)
    }
    func copyToPasteboard() {
        let size = NSSize(width: self.width, height: self.height)
        let nsImage = NSImage(cgImage: self, size: size)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.writeObjects([nsImage])
    }
}


#endif
