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
    
    public enum NormalizeMode: String, Hashable {
        case none
        case basedOnWidth
        case basedOnHeight
        case basedOnLarger
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
        normalizeMode: NormalizeMode
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
        if normalizeMode != .none {
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
            switch normalizeMode {
            case .basedOnWidth:
                let ratio = largestY / largestX
                return finalVertices.map { f3($0.x / largestX, $0.y * ratio, 0)}
            case .basedOnHeight:
                let ratio = largestX / largestY
                return finalVertices.map { f3($0.x * ratio, $0.y / largestY, 0)}
            case .basedOnLarger:
                if largestX > largestY {
                    let ratio = largestY / largestX
                    return finalVertices.map { f3($0.x / largestX, $0.y * ratio, 0)}
                } else {
                    let ratio = largestX / largestY
                    return finalVertices.map { f3($0.x * ratio, $0.y / largestY, 0)}
                }
            case .none:
                throw Error.zeroVertices
            }
        } else {
            return finalVertices
        }
    }
}
