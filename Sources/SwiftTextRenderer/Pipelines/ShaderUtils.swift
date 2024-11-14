//
//  ShaderUtils.swift
//  SwiftTextRenderer
//
//  Created by Yuki Kuwashima on 2024/11/13.
//

import MetalKit

internal enum ShaderUtils {
    static let device: MTLDevice = MTLCreateSystemDefaultDevice()!
    static let library: MTLLibrary = try! device.makeDefaultLibrary(bundle: .module)
    static let commandQueue: MTLCommandQueue = device.makeCommandQueue()!
}
