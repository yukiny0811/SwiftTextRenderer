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
//        textRenderer.render("あいう", color: f4(1, 1, 1, 1), commandBuffer: commandBuffer, view: view)
        textRenderer.render(
            "yeah",
            color: f4(1, 1, 1, 1),
            commandBuffer: commandBuffer,
            camera: Camera(
                width: Float(drawable.texture.width),
                height: Float(drawable.texture.height),
                translation: f3(0, 0, -30),
                rotationAngle: 0,
                rotationAxis: f3(1, 0, 0)
            ),
            renderPassDescriptor: view.currentRenderPassDescriptor!
        )
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
                    renderer.textRenderer = TextRenderer(fontName: fontName)
                    renderer.textRenderer.cacheCaracters(from: "あいうえお桑島yeah")
                }
        }
    }

    func getAvailableFonts() -> [String] {
        return UIFont.familyNames.flatMap {
            UIFont.fontNames(forFamilyName: $0)
        }
    }
}
