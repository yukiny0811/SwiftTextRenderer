//
//  ContentView.swift
//  SwiftTextRendereriOS
//
//  Created by Yuki Kuwashima on 2024/11/13.
//

import SwiftUI
import EasyMetalShader
import SwiftTextRenderer
import Foundation

class MyRenderer: ShaderRenderer {

    var textRenderer = TextRenderer()

    override init() {
        super.init()
        textRenderer.cacheCaracters(from: "あいうえお桑島yeah")
    }

    override func draw(view: MTKView, drawable: any CAMetalDrawable) {
        view.drawableSize = .init(width: view.frame.width * 2, height: view.frame.height * 2)
        let commandBuffer = ShaderCore.commandQueue.makeCommandBuffer()!
        
        textRenderer.renderText(
            commandBuffer: commandBuffer,
            camera: Camera(
                width: Float(drawable.texture.width),
                height: Float(drawable.texture.height),
                translation: f3(0, 0, -100),
                rotationAngle: 0,
                rotationAxis: f3(1, 0, 0)
            ),
            renderPassDescriptor: view.currentRenderPassDescriptor!
        ) { encoder in
            textRenderer.renderText(
                encoder: encoder,
                "yeah",
                color: f4(1, 1, 1, 1),
                drawBorder: false,
                borderWidth: 1,
                primitiveType: .triangle
            )
            textRenderer.renderText(
                encoder: encoder,
                "yeah",
                color: f4(0.5, 0.8, 1, 1),
                drawBorder: true,
                borderWidth: 1,
                primitiveType: .triangle
            )
        }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

struct ContentView: View {
    let renderer = MyRenderer()
    @State var fontName: String = "HiraginoSans-W3"
    var body: some View {
        NavigationStack {
            EasyShaderView(renderer: renderer)
                .toolbar {
                    ToolbarItem {
                        Picker("フォント名", selection: $fontName) {
                            ForEach(getAvailableFonts(), id: \.self) { f in
                                Text(f).tag(f)
                            }
                        }
                    }
                }
                .onChange(of: fontName) {
                    reset()
                }
                .onAppear {
                    reset()
                }
        }
    }

    func reset() {
        renderer.textRenderer = TextRenderer(fontName: fontName, fontSize: 24)
        renderer.textRenderer.cacheCaracters(from: "あいうえお桑島yeah")
    }

    func getAvailableFonts() -> [String] {
        return UIFont.familyNames.flatMap {
            UIFont.fontNames(forFamilyName: $0)
        }
    }
}
