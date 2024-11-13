//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/02.
//

import Foundation
import CoreText

public extension SwiftyCTFont {
    
    func getGlyphsForCharacters(
        characters: UnsafePointer<UniChar>,
        glyphs: UnsafeMutablePointer<CGGlyph>,
        count: CFIndex
    ) -> Bool {
        return CTFontGetGlyphsForCharacters(ctFont, characters, glyphs, count)
    }
    
    func drawGlyphs(
        glyphs: UnsafePointer<CGGlyph>,
        positions: UnsafePointer<CGPoint>,
        count: Int,
        context: CGContext
    ) {
        CTFontDrawGlyphs(ctFont, glyphs, positions, count, context)
    }
    
    func getLigatureCaretPositions(
        glyph: CGGlyph,
        positions: UnsafeMutablePointer<CGFloat>?,
        maxPositions: CFIndex
    ) -> CFIndex {
        return CTFontGetLigatureCaretPositions(ctFont, glyph, positions, maxPositions)
    }
}
