//
//  ContentView.swift
//  ExampleMacos
//
//  Created by Yuki Kuwashima on 2025/01/29.
//

import SwiftUI
import SwiftTextRenderer
import SwiftyCreatives

struct ContentView: View {
    let sketch = MySketch()
    var body: some View {
        SketchView(sketch)
    }
}

class MySketch: Sketch {
    
    override func draw(encoder: any SCEncoder) {
        
        let textMesh = try! SwiftTextRenderer.getVertices(for: "THIS IS TEXT", normalizeMode: .basedOnLarger)
        let buf = ShaderCore.device.makeBuffer(bytes: textMesh, length: MemoryLayout<f3>.stride * textMesh.count)!
        color(1)
        mesh(buf)
    }
}
