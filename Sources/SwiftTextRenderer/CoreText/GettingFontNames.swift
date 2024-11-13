//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/29.
//

import Foundation
import CoreText

public extension SwiftyCTFont {
    
    func copyPostScriptName() -> String {
        return CTFontCopyPostScriptName(ctFont) as String
    }
    
    func copyFamilyName() -> String {
        return CTFontCopyFamilyName(ctFont) as String
    }
    
    func copyFullName() -> String {
        return CTFontCopyFullName(ctFont) as String
    }
    
    func copyDisplayName() -> String {
        return CTFontCopyDisplayName(ctFont) as String
    }
    
    func copyFontName(nameKey: String) -> String? {
        return CTFontCopyName(ctFont, nameKey as CFString) as? String
    }
    
    func copyLocalizedName(nameKey: String, actualLanguage: UnsafeMutablePointer<Unmanaged<CFString>?>?) -> String? {
        return CTFontCopyLocalizedName(ctFont, nameKey as CFString, actualLanguage) as? String
    }
}
