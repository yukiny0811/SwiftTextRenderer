//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/02.
//

import Foundation
import CoreText

public extension SwiftyCTFont {
    
    func copyVariationAxes() -> CFArray? {
        return CTFontCopyVariationAxes(ctFont)
    }
    
    func copyVariation() -> CFDictionary? {
        return CTFontCopyVariation(ctFont)
    }
}
