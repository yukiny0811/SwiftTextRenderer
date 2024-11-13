//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/02.
//

import Foundation
import CoreText

public extension SwiftyCTFont {
    
    func copyFeatures() -> CFArray? {
        return CTFontCopyFeatures(ctFont)
    }
    
    func copyFeatureSettings() -> CFArray? {
        return CTFontCopyFeatureSettings(ctFont)
    }
}
