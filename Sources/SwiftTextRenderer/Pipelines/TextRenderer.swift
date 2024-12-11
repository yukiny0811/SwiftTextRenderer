//
//  File.swift
//  SwiftTextRenderer
//
//  Created by Yuki Kuwashima on 2024/11/13.
//

import MetalKit

public enum TextRendererUtils {

    private static let vertexDescriptor: MTLVertexDescriptor = {
        let desc: MTLVertexDescriptor = MTLVertexDescriptor()
        desc.attributes[0].format = .float3
        desc.attributes[0].offset = 0
        desc.attributes[0].bufferIndex = 0
        desc.layouts[0].stride = 16
        desc.layouts[0].stepRate = 1
        desc.layouts[0].stepFunction = .perVertex
        return desc
    }()

    private static let mainVertFunction: MTLFunction = ShaderUtils.library.makeFunction(name: "mainVert")!
    private static let mainFragFunction: MTLFunction = ShaderUtils.library.makeFunction(name: "mainFrag")!
    internal static let mainPipelineState: MTLRenderPipelineState = {
        let desc: MTLRenderPipelineDescriptor = MTLRenderPipelineDescriptor()
        desc.vertexFunction = mainVertFunction
        desc.fragmentFunction = mainFragFunction
        desc.colorAttachments[0].pixelFormat = .bgra8Unorm
        desc.vertexDescriptor = vertexDescriptor
        return try! ShaderUtils.device.makeRenderPipelineState(descriptor: desc)
    }()
}

public class TextRenderer {

    private let factory: TextFactory
    private var customMatrix: [f4x4] = [f4x4.createIdentity()]

    public init(
        fontName: String = "HiraginoSans-W3",
        fontSize: Float = 10.0,
        bounds: CGSize = .zero,
        pivot: f2 = .zero,
        textAlignment: CTTextAlignment = .natural,
        verticalAlignment: PathText.VerticalAlignment = .center,
        kern: Float = 0.0,
        lineSpacing: Float = 0.0,
        isClockwiseFont: Bool = true
    ) {
        self.factory = TextFactory(
            fontName: fontName,
            fontSize: fontSize,
            bounds: bounds,
            pivot: pivot,
            textAlignment: textAlignment,
            verticalAlignment: verticalAlignment,
            kern: kern,
            lineSpacing: lineSpacing,
            isClockwiseFont: isClockwiseFont
        )
    }

    public func unCacheCharacters() {
        factory.cached = [:]
    }
    public func cacheCaracters(from str: String) {
        for c in str {
            factory.cacheCharacter(char: c)
        }
    }
    
    public func renderText(
        commandBuffer: MTLCommandBuffer,
        camera: Camera,
        renderPassDescriptor: MTLRenderPassDescriptor,
        process: (_ encoder: MTLRenderCommandEncoder) -> ()
    ) {
        customMatrix = [f4x4.createIdentity()]
        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        encoder.setRenderPipelineState(TextRendererUtils.mainPipelineState)
        encoder.setViewport(
            MTLViewport(
                originX: 0,
                originY: 0,
                width: Double(camera.frameWidth) * Double(1),
                height: Double(camera.frameHeight) * Double(1),
                znear: -1,
                zfar: 1
            )
        )
        encoder.setVertexBytes([camera.perspectiveMatrix], length: f4x4.memorySize, index: 13)
        encoder.setVertexBytes([camera.viewMatrix], length: f4x4.memorySize, index: 14)
        encoder.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: 15)
        process(encoder)
        encoder.endEncoding()
    }
    
    public func renderText(encoder: MTLRenderCommandEncoder, _ str: String, color: f4, drawBorder: Bool, borderWidth: Float, primitiveType: MTLPrimitiveType) {
        encoder.setVertexBytes([color], length: f4.memorySize, index: 16)
        text(encoder: encoder, str, factory: factory, primitiveType: primitiveType, drawBorder: drawBorder, borderWidth: borderWidth)
    }

    public func render(
        _ str: String,
        color: f4,
        commandBuffer: MTLCommandBuffer,
        camera: Camera,
        renderPassDescriptor: MTLRenderPassDescriptor,
        primitiveType: MTLPrimitiveType,
        drawBorder: Bool = false,
        borderWidth: Float
    ) {
        customMatrix = [f4x4.createIdentity()]
        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        encoder.setRenderPipelineState(TextRendererUtils.mainPipelineState)
        encoder.setViewport(
            MTLViewport(
                originX: 0,
                originY: 0,
                width: Double(camera.frameWidth) * Double(1),
                height: Double(camera.frameHeight) * Double(1),
                znear: -1,
                zfar: 1
            )
        )
        encoder.setVertexBytes([camera.perspectiveMatrix], length: f4x4.memorySize, index: 13)
        encoder.setVertexBytes([camera.viewMatrix], length: f4x4.memorySize, index: 14)
        encoder.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: 15)
        encoder.setVertexBytes([color], length: f4.memorySize, index: 16)
        text(encoder: encoder, str, factory: factory, primitiveType: primitiveType, drawBorder: drawBorder, borderWidth: borderWidth)
        encoder.endEncoding()
    }

    public func render(
        _ str: String,
        color: f4,
        commandBuffer: MTLCommandBuffer,
        view: MTKView,
        primitiveType: MTLPrimitiveType,
        drawBorder: Bool = false,
        borderWidth: Float
    ) {
        guard let drawable = view.currentDrawable else {
            return
        }
        let camera = Camera(width: Float(drawable.texture.width), height: Float(drawable.texture.height))
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        renderPassDescriptor.colorAttachments[0].clearColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        render(
            str,
            color: color,
            commandBuffer: commandBuffer,
            camera: camera,
            renderPassDescriptor: renderPassDescriptor,
            primitiveType: primitiveType,
            drawBorder: drawBorder,
            borderWidth: borderWidth
        )
    }

    func char(
        encoder: MTLRenderCommandEncoder,
        _ character: Character,
        factory: TextFactory,
        primitiveType: MTLPrimitiveType = .triangle,
        drawBorder: Bool = false,
        borderWidth: Float,
        applyTransformBefore: ((_ advances: f2, _ offset: f2, _ size: f2) -> ())? = nil,
        applyTransformAfter: ((_ advances: f2, _ offset: f2, _ size: f2) -> ())? = nil
    ) {
        if let cached = factory.cached[character] {
            applyTransformBefore?(cached.advances, cached.offset, cached.size)
            encoder.setVertexBytes([f3.zero], length: f3.memorySize, index: 10)
            encoder.setVertexBytes([f3.zero], length: f3.memorySize, index: 11)
            encoder.setVertexBytes([f3.one], length: f3.memorySize, index: 12)
            if drawBorder {
                let buffers = cached.borderPath.map { glyph in
                    let widthedBorderPath = createPathWithBorderWidth(path: glyph.map { $0 + cached.offset }, width: borderWidth)
                    return ShaderUtils.device.makeBuffer(bytes: widthedBorderPath.map { f3($0.x, $0.y, 0) }, length: widthedBorderPath.count * f3.memorySize)!
                }
                for border in buffers {
                    encoder.setVertexBuffer(border, offset: 0, index: 0)
                    encoder.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: border.length / f3.memorySize)
                }
            } else {
                encoder.setVertexBuffer(cached.buffer, offset: 0, index: 0)
                encoder.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: cached.verticeCount)
            }
            applyTransformAfter?(cached.advances, cached.offset, cached.size)
        } else {
            print("no caches for \(character)")
        }
    }
    
    func createPathWithBorderWidth(path: [simd_float2], width: Float) -> [simd_float2] {
        guard path.count > 2 else {
            return []
        }
        let closedPath = path
        let halfWidth = width * 0.5
        var normals: [simd_float2] = []
        normals.reserveCapacity(closedPath.count)
        for i in 0..<closedPath.count {
            let current = closedPath[i]
            let next = closedPath[(i + 1) % closedPath.count]
            let edge = next - current
            let normal = simd_normalize(simd_float2(-edge.y, edge.x))
            normals.append(normal)
        }
        var vertexNormals: [simd_float2] = []
        vertexNormals.reserveCapacity(closedPath.count)
        for i in 0..<closedPath.count {
            let prevN = normals[(i - 1 + closedPath.count) % closedPath.count]
            let currN = normals[i]
            var vn = prevN + currN
            let length = simd_length(vn)
            if length > 1e-6 {
                vn = vn / length
            } else {
                vn = currN
            }
            vertexNormals.append(vn)
        }
        let outerPath = zip(closedPath, vertexNormals).map { $0 + $1 * halfWidth }
        let innerPath = zip(closedPath, vertexNormals).map { $0 - $1 * halfWidth }
        var triangles: [simd_float2] = []
        for i in 0..<closedPath.count {
            let iNext = (i + 1) % closedPath.count
            
            let p0 = innerPath[i]
            let p1 = outerPath[i]
            let p2 = outerPath[iNext]
            let p3 = innerPath[iNext]
            
            triangles.append(p0)
            triangles.append(p1)
            triangles.append(p2)
            
            triangles.append(p0)
            triangles.append(p2)
            triangles.append(p3)
        }
        
        return triangles
    }

    func text(encoder: MTLRenderCommandEncoder, _ str: String, factory: TextFactory, primitiveType: MTLPrimitiveType = .triangle, drawBorder: Bool = false, borderWidth: Float) {
        push(encoder: encoder) {
            if str.isEmpty { return }
            let spacerFactor: Float = factory.cached[str.first!]?.advances.x ?? 0
            let totalLength: Float = str[str.startIndex..<str.index(before: str.endIndex)].reduce(0) { partialResult, c in
                if c == " " {
                    return partialResult + spacerFactor
                }
                if let cached = factory.cached[c] {
                    return partialResult + cached.advances.x
                }
                return partialResult
            }
            translate(f3(-totalLength/2, 0, 0), encoder: encoder)
            for c in str {
                if c == " " {
                    translate(f3(spacerFactor, 0, 0), encoder: encoder)
                    continue
                }
                char(encoder: encoder, c, factory: factory, primitiveType: primitiveType, drawBorder: drawBorder, borderWidth: borderWidth) { advances, offset, size in

                } applyTransformAfter: { advances, offset, size in
                    self.translate(f3(advances.x, 0, 0), encoder: encoder)
                }
            }
        }
    }

    public func rotate(encoder: MTLRenderCommandEncoder, _ rad: Float, axis: f3) {
        let rotateMatrix = f4x4.createRotation(angle: rad, axis: axis)
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * rotateMatrix
        setCustomMatrix(encoder: encoder)
    }

    public func translate(_ value: f3, encoder: MTLRenderCommandEncoder) {
        let translateMatrix = f4x4.createTranslation(value.x, value.y, value.z)
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * translateMatrix
        setCustomMatrix(encoder: encoder)
    }
    
    public func scale(_ value: f3, encoder: MTLRenderCommandEncoder) {
        let scaleMatrix = f4x4.createScale(value.x, value.y, value.z)
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * scaleMatrix
        setCustomMatrix(encoder: encoder)
    }

    public func pushMatrix(encoder: MTLRenderCommandEncoder) {
        self.customMatrix.append(f4x4.createIdentity())
        setCustomMatrix(encoder: encoder)
    }

    public func popMatrix(encoder: MTLRenderCommandEncoder) {
        let _ = self.customMatrix.popLast()
        setCustomMatrix(encoder: encoder)
    }

    public func push(encoder: MTLRenderCommandEncoder, _ process: () -> Void) {
        pushMatrix(encoder: encoder)
        process()
        popMatrix(encoder: encoder)
    }

    public func setCustomMatrix(encoder: MTLRenderCommandEncoder) {
        encoder.setVertexBytes(
            [self.customMatrix.reduce(f4x4.createIdentity(), *)],
            length: f4x4.memorySize,
            index: 15
        )
    }
}
