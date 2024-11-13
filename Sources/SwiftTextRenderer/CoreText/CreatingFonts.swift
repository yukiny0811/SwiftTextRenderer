//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/29.
//

import CoreText
import Foundation

public class SwiftyCTFont {
    
    public var ctFont: CTFont
    
    public init(font: CTFont) {
        self.ctFont = font
    }
    
    // MARK: creating fonts
    
    public init(
        name: String,
        size: CGFloat,
        matrix: UnsafePointer<CGAffineTransform>?,
        options: [CTFontOptions]?
    ) {
        if let options {
            var rawValue: CFOptionFlags = 0
            options.forEach {
                rawValue += $0.rawValue
            }
            let summedOptions = CTFontOptions(
                rawValue: rawValue
            )
            self.ctFont = CTFontCreateWithNameAndOptions(
                name as CFString,
                size,
                matrix,
                summedOptions
            )
        } else {
            self.ctFont = CTFontCreateWithName(name as CFString, size, matrix)
        }
    }
    
    public init(
        descriptor: CTFontDescriptor,
        size: CGFloat,
        matrix: UnsafePointer<CGAffineTransform>?,
        options: [CTFontOptions]?
    ) {
        self.ctFont = CTFontCreateWithFontDescriptor(descriptor, size, matrix)
        if let options {
            var rawValue: CFOptionFlags = 0
            options.forEach {
                rawValue += $0.rawValue
            }
            let summedOptions = CTFontOptions(
                rawValue: rawValue
            )
            self.ctFont = CTFontCreateWithFontDescriptorAndOptions(
                descriptor,
                size,
                matrix,
                summedOptions
            )
        } else {
            self.ctFont = CTFontCreateWithFontDescriptor(
                descriptor,
                size,
                matrix
            )
        }
    }
    
    public init?(uiType: CTFontUIFontType, size: CGFloat, language: String?) {
        if let language {
            guard let font = CTFontCreateUIFontForLanguage(uiType, size, language as CFString) else {
                return nil
            }
            self.ctFont = font
        } else {
            guard let font = CTFontCreateUIFontForLanguage(uiType, size, nil) else {
                return nil
            }
            self.ctFont = font
        }
    }
    
    public init(
        font: CTFont,
        size: CGFloat,
        matrix: UnsafePointer<CGAffineTransform>?,
        attributes: CTFontDescriptor?
    ) {
        self.ctFont = CTFontCreateCopyWithAttributes(font, size, matrix, attributes)
    }
    
    public init?(
        font: CTFont,
        size: CGFloat,
        matrix: UnsafePointer<CGAffineTransform>?,
        symTraitValue: CTFontSymbolicTraits,
        symTraitMask: CTFontSymbolicTraits
    ) {
        guard let font = CTFontCreateCopyWithSymbolicTraits(font, size, matrix, symTraitValue, symTraitMask) else {
            return nil
        }
        self.ctFont = font
    }
    
    public init?(
        font: CTFont,
        size: CGFloat,
        matrix: UnsafePointer<CGAffineTransform>?,
        family: String
    ) {
        guard let font = CTFontCreateCopyWithFamily(font, size, matrix, family as CFString) else {
            return nil
        }
        self.ctFont = font
    }
    
    public init(currentFont: CTFont, string: String, range: CFRange, language: String?) {
        if let language {
            self.ctFont = CTFontCreateForStringWithLanguage(currentFont, string as CFString, range, language as CFString)
        } else {
            self.ctFont = CTFontCreateForString(currentFont, string as CFString, range)
        }
    }
}
