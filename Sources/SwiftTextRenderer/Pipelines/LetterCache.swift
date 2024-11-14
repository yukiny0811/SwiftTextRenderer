//
//  File.swift
//  SwiftTextRenderer
//
//  Created by Yuki Kuwashima on 2024/11/13.
//

import Metal

public struct LetterCache {
    public var buffer: MTLBuffer
    public var verticeCount: Int
    public var offset: f2
    public var size: f2
    public var advances: f2
}
