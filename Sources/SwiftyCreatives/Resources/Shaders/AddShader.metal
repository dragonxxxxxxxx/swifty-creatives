//
//  AddShader.metal
//
//
//  Created by Yuki Kuwashima on 2022/12/15.
//

#include <metal_stdlib>
#include "Types.metal"
using namespace metal;

vertex RasterizerData add_vertex (const Vertex vIn [[ stage_in ]],
                                  const device FrameUniforms_ModelPos& uniformModelPos [[ buffer(1) ]],
                                  const device FrameUniforms_ModelRot& uniformModelRot [[ buffer(2) ]],
                                  const device FrameUniforms_ModelScale& uniformModelScale [[ buffer(3) ]],
                                  const device FrameUniforms_ProjectionMatrix& uniformProjectionMatrix [[ buffer(4) ]],
                                  const device FrameUniforms_ViewMatrix& uniformViewMatrix [[ buffer(5) ]]) {
            
    RasterizerData rd;
    
    float4x4 modelTransMatrix = float4x4(float4(1.0, 0.0, 0.0, uniformModelPos.value.x),
                                         float4(0.0, 1.0, 0.0, uniformModelPos.value.y),
                                         float4(0.0, 0.0, 1.0, uniformModelPos.value.z),
                                         float4(0.0, 0.0, 0.0, 1.0));

    const float cosX = cos(uniformModelRot.value.x);
    const float sinX = sin(uniformModelRot.value.x);
    float4x4 modelRotateXMatrix = float4x4(float4(1.0, 0.0, 0.0, 0.0),
                                           float4(0.0, cosX, -sinX, 0.0),
                                           float4(0.0, sinX, cosX, 0.0),
                                           float4(0.0, 0.0, 0.0, 1.0));

    const float cosY = cos(uniformModelRot.value.y);
    const float sinY = sin(uniformModelRot.value.y);
    float4x4 modelRotateYMatrix = float4x4(float4(cosY, 0.0, sinY, 0.0),
                                           float4(0.0, 1.0, 0.0, 0.0),
                                           float4(-sinY, 0.0, cosY, 0.0),
                                           float4(0.0, 0.0, 0.0, 1.0));

    const float cosZ = cos(uniformModelRot.value.z);
    const float sinZ = sin(uniformModelRot.value.z);
    float4x4 modelRotateZMatrix = float4x4(float4(cosZ, -sinZ, 0.0, 0.0),
                                           float4(sinZ, cosZ, 0.0, 0.0),
                                           float4(0.0, 0.0, 1.0, 0.0),
                                           float4(0.0, 0.0, 0.0, 1.0));
                                                
    float4x4 modelScaleMatrix = float4x4(float4(uniformModelScale.value.x, 0.0, 0.0, 0.0),
                                         float4(0.0, uniformModelScale.value.y, 0.0, 0.0),
                                         float4(0.0, 0.0, uniformModelScale.value.z, 0.0),
                                         float4(0.0, 0.0, 0.0, 1.0));
    
    float4x4 modelMatrix = transpose(modelScaleMatrix * modelRotateXMatrix * modelRotateYMatrix * modelRotateZMatrix * modelTransMatrix);
    
    rd.position = uniformProjectionMatrix.value * uniformViewMatrix.value * modelMatrix * float4(vIn.position, 1.0);
    rd.color = vIn.color;
    rd.uv = vIn.uv;
    return rd;
}

fragment half4 add_fragment (RasterizerData rd [[stage_in]],
                             half4 c [[color(0)]],
                             const device FrameUniforms_HasTexture& uniformHasTexture [[ buffer(6) ]],
                             texture2d<half> tex [[ texture(0) ]]) {
    if (uniformHasTexture.value) {
        constexpr sampler textureSampler (coord::pixel, address::clamp_to_edge, filter::linear);
        const half4 colorSample = tex.sample(textureSampler, float2(rd.uv.x*tex.get_width(), rd.uv.y*tex.get_height()));
        return colorSample + c;
    }
    return half4(rd.color) + c;
}
