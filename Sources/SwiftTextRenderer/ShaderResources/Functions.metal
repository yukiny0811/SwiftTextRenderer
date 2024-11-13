//
//  File.metal
//  SwiftTextRenderer
//
//  Created by Yuki Kuwashima on 2024/11/13.
//

#include <metal_stdlib>
using namespace metal;

inline float4x4 createModelMatrix
(
    const float3 modelPos,
    const float3 modelRot,
    const float3 modelScale,
    const float4x4 customMatrix
) {
    float4x4 modelTransMatrix = float4x4(float4(1.0, 0.0, 0.0, 0.0),
                                         float4(0.0, 1.0, 0.0, 0.0),
                                         float4(0.0, 0.0, 1.0, 0.0),
                                         float4(modelPos, 1.0));

    const float cosX = cos(modelRot.x);
    const float sinX = sin(modelRot.x);
    float4x4 modelRotateXMatrix = float4x4(float4(1.0, 0.0, 0.0, 0.0),
                                           float4(0.0, cosX, sinX, 0.0),
                                           float4(0.0, -sinX, cosX, 0.0),
                                           float4(0.0, 0.0, 0.0, 1.0));

    const float cosY = cos(modelRot.y);
    const float sinY = sin(modelRot.y);
    float4x4 modelRotateYMatrix = float4x4(float4(cosY, 0.0, -sinY, 0.0),
                                           float4(0.0, 1.0, 0.0, 0.0),
                                           float4(sinY, 0.0, cosY, 0.0),
                                           float4(0.0, 0.0, 0.0, 1.0));

    const float cosZ = cos(modelRot.z);
    const float sinZ = sin(modelRot.z);
    float4x4 modelRotateZMatrix = float4x4(float4(cosZ, sinZ, 0.0, 0.0),
                                           float4(-sinZ, cosZ, 0.0, 0.0),
                                           float4(0.0, 0.0, 1.0, 0.0),
                                           float4(0.0, 0.0, 0.0, 1.0));

    float4x4 modelScaleMatrix = float4x4(float4(modelScale.x, 0.0, 0.0, 0.0),
                                       float4(0.0, modelScale.y, 0.0, 0.0),
                                       float4(0.0, 0.0, modelScale.z, 0.0),
                                       float4(0.0, 0.0, 0.0, 1.0));

    float4x4 modelMatrix = customMatrix * modelTransMatrix * modelRotateZMatrix * modelRotateYMatrix * modelRotateXMatrix * modelScaleMatrix;
    return modelMatrix;
}


