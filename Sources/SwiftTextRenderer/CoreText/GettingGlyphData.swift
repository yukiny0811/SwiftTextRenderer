//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/02.
//

import Foundation
import CoreText

public extension SwiftyCTFont {
    
    func createPathForGlyph(glyph: CGGlyph, matrix: UnsafePointer<CGAffineTransform>?) -> CGPath? {
        return CTFontCreatePathForGlyph(ctFont, glyph, matrix)
    }
    
    func getGlyphWithName(glyphName: String) -> CGGlyph {
        return CTFontGetGlyphWithName(ctFont, glyphName as CFString)
    }
    
    func getBoundingRectsForGlyphs(
        orientation: CTFontOrientation,
        glyphs: UnsafePointer<CGGlyph>,
        boundingRects: UnsafeMutablePointer<CGRect>?,
        count: CFIndex
    ) -> CGRect {
        CTFontGetBoundingRectsForGlyphs(ctFont, orientation, glyphs, boundingRects, count)
    }
    
    func getAdvancesForGlyphs(
        orientation: CTFontOrientation,
        glyphs: UnsafePointer<CGGlyph>,
        advances: UnsafeMutablePointer<CGSize>?,
        count: CFIndex
    ) -> Double {
        return CTFontGetAdvancesForGlyphs(ctFont, orientation, glyphs, advances, count)
    }
    
    func getOpticalBoundsForGlyphs(
        glyphs: UnsafePointer<CGGlyph>,
        boundingRects: UnsafeMutablePointer<CGRect>?,
        count: CFIndex,
        options: CFOptionFlags
    ) -> CGRect {
        return CTFontGetOpticalBoundsForGlyphs(ctFont, glyphs, boundingRects, count, options)
    }
    
    func getVerticalTranslationsForGlyphs(
        glyphs: UnsafePointer<CGGlyph>,
        translations: UnsafeMutablePointer<CGSize>,
        count: CFIndex
    ) {
        CTFontGetVerticalTranslationsForGlyphs(ctFont, glyphs, translations, count)
    }
}
