//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/29.
//

import CoreText
import Foundation

public extension SwiftyCTFont {
    
    func copyFontDescriptor() -> CTFontDescriptor {
        return CTFontCopyFontDescriptor(ctFont)
    }
    
    func copyAttribute(attribute: String) -> CFTypeRef? {
        return CTFontCopyAttribute(ctFont, attribute as CFString)
    }
    
    func getSize() -> CGFloat {
        return CTFontGetSize(ctFont)
    }
    
    func getMatrix() -> CGAffineTransform {
        return CTFontGetMatrix(ctFont)
    }
    
    func getSymbolicTraits() -> CTFontSymbolicTraits {
        return CTFontGetSymbolicTraits(ctFont)
    }
    
    func copyTraits() -> CFDictionary {
        return CTFontCopyTraits(ctFont)
    }
    
    func copyDefaultCascadeListForLanguages(languagePrefList: CFArray?) -> CFArray? {
        return CTFontCopyDefaultCascadeListForLanguages(ctFont, languagePrefList)
    }
}
