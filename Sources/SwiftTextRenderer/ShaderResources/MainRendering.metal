//
//  File.metal
//  SwiftTextRenderer
//
//  Created by Yuki Kuwashima on 2024/11/13.
//

#include <metal_stdlib>
#include "Types.metal"
#include "Functions.metal"
using namespace metal;

vertex RasterizerData mainVert
(
    const Vertex vIn [[ stage_in ]],
    const device float3& modelPos [[ buffer(10) ]],
    const device float3& modelRot [[ buffer(11) ]],
    const device float3& modelScale [[ buffer(12) ]],
    const device float4x4& projectionMatrix [[ buffer(13) ]],
    const device float4x4& viewMatrix [[ buffer(14) ]],
    const device float4x4& customMatrix [[ buffer(15) ]],
    const device float4& modelColor [[ buffer(16) ]]
 ) {
    float4x4 modelMatrix = createModelMatrix(modelPos, modelRot, modelScale, customMatrix);

    RasterizerData rd;
    rd.position = projectionMatrix * viewMatrix * modelMatrix * float4(vIn.position, 1.0);
    rd.color = modelColor;
    return rd;
}

fragment FragOut mainFrag
(
    RasterizerData rd [[ stage_in ]]
 ) {
    half4 resultColor = half4(rd.color);

    FragOut out;
    out.color = resultColor;
    return out;
}


