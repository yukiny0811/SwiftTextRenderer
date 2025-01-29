// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import CoreGraphics
import CoreText

public enum SwiftTextRenderer {
    
    public enum Error: String, LocalizedError {
        public var errorDescription: String? { self.rawValue }
        case zeroVertices
    }
    
    public static func getVertices(
        for text: String,
        fontName: String = "AppleSDGothicNeo-Bold",
        fontSize: Float = 24,
        bounds: CGSize = .zero,
        pivot: f2 = .zero,
        textAlignment: CTTextAlignment = .natural,
        verticalAlignment: PathText.VerticalAlignment = .center,
        kern: Float = 0.0,
        lineSpacing: Float = 0.0,
        normalized: Bool
    ) throws -> [f3] {
        let pathText = PathText(
            text: text,
            fontName: fontName,
            fontSize: fontSize,
            bounds: bounds,
            pivot: pivot,
            textAlignment: textAlignment,
            verticalAlignment: verticalAlignment,
            kern: kern,
            lineSpacing: lineSpacing,
            maxDepth: 1
        )
        let triangulated = GlyphUtil.MainFunctions.triangulate(pathText.calculatedPaths)
        
        var finalVertices: [f3] = []
        for letter in triangulated {
            for portion in letter.glyphLines {
                finalVertices += portion
            }
        }
        if finalVertices.count == 0 {
            throw Error.zeroVertices
        }
        if normalized {
            var largestX: Float = 0
            var largestY: Float = 0
            for vert in finalVertices {
                if vert.x > largestX {
                    largestX = vert.x
                }
                if vert.y < largestY {
                    largestY = vert.y
                }
            }
            let finalVerticesNormalized = finalVertices.map { f3($0.x / largestX, $0.y / largestY, 0)}
            return finalVerticesNormalized
        } else {
            return finalVertices
        }
    }
}
