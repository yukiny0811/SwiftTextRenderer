//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/02.
//

import Foundation
import CoreText

public extension SwiftyCTFont {
    
    func copyGraphicsFont(
        attributes: UnsafeMutablePointer<Unmanaged<CTFontDescriptor>?>?
    ) -> CGFont {
        return CTFontCopyGraphicsFont(ctFont, attributes)
    }
    
    convenience init(
        graphicsFont: CGFont,
        size: CGFloat,
        matrix: UnsafePointer<CGAffineTransform>?,
        attributes: CTFontDescriptor?
    ) {
        self.init(font: CTFontCreateWithGraphicsFont(graphicsFont, size, matrix, attributes))
    }
}
