//
//  File.metal
//  SwiftTextRenderer
//
//  Created by Yuki Kuwashima on 2024/11/13.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float3 position [[ attribute(0) ]];
};

struct RasterizerData {
    float4 position [[ position ]];
    float4 color;
};

struct FragOut {
    half4 color [[ color(0) ]];
};
