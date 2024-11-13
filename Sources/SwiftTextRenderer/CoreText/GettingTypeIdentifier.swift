//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/02.
//

import Foundation
import CoreText

public extension SwiftyCTFont {
    
    static func getTypeID() -> CFTypeID {
        return CTFontGetTypeID()
    }
}
