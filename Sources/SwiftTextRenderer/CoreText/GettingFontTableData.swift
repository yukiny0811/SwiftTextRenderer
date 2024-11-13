//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/02.
//

import Foundation
import CoreText

public extension SwiftyCTFont {
    
    func copyAvailableTables(
        options: CTFontTableOptions
    ) -> CFArray? {
        return CTFontCopyAvailableTables(ctFont, options)
    }
    
    func copyTable(
        table: CTFontTableTag,
        options: CTFontTableOptions
    ) -> CFData? {
        return CTFontCopyTable(ctFont, table, options)
    }
}
