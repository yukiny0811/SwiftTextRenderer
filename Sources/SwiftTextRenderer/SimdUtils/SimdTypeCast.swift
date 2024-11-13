//
//  SimdTypeCast.swift
//  SwiftTextRenderer
//
//  Created by Yuki Kuwashima on 2024/11/13.
//

import simd
import CoreGraphics

public extension CGPoint {
    var f2Value: f2 {
        f2(Float(self.x), Float(self.y))
    }
}

public extension CGSize {
    var f2Value: f2 {
        f2(Float(self.width), Float(self.height))
    }
}

public extension f2 {
    var cgPoint: CGPoint {
        CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
    var cgSize: CGSize {
        CGSize(width: CGFloat(x), height: CGFloat(y))
    }
}
