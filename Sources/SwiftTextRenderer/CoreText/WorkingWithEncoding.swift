//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/29.
//

import Foundation
import CoreText

public extension SwiftyCTFont {
    
    func copyCharacterSet() -> CFCharacterSet {
        return CTFontCopyCharacterSet(ctFont)
    }
    
    func getStringEncoding() -> CFStringEncoding {
        return CTFontGetStringEncoding(ctFont)
    }
    
    func copySupportedLanguages() -> CFArray {
        return CTFontCopySupportedLanguages(ctFont)
    }
}
