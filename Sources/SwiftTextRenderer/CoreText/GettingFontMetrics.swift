//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/29.
//

import Foundation
import CoreText

public extension SwiftyCTFont {
    
    func getAscent() -> CGFloat {
        return CTFontGetAscent(ctFont)
    }
    
    func getDescent() -> CGFloat {
        return CTFontGetDescent(ctFont)
    }
    
    func getLeading() -> CGFloat {
        return CTFontGetLeading(ctFont)
    }
    
    func getUnitsPerEm() -> UInt32 {
        return CTFontGetUnitsPerEm(ctFont)
    }
    
    func getGlyphCount() -> CFIndex {
        return CTFontGetGlyphCount(ctFont)
    }
    
    func getBoundingBox() -> CGRect {
        return CTFontGetBoundingBox(ctFont)
    }
    
    func getUnderlinePosition() -> CGFloat {
        return CTFontGetUnderlinePosition(ctFont)
    }
    
    func getUnderlineThickness() -> CGFloat {
        return CTFontGetUnderlineThickness(ctFont)
    }
    
    func getSlantAngle() -> CGFloat {
        return CTFontGetSlantAngle(ctFont)
    }
    
    func getCapHeight() -> CGFloat {
        return CTFontGetCapHeight(ctFont)
    }
    
    func getXHeight() -> CGFloat {
        return CTFontGetXHeight(ctFont)
    }
}
