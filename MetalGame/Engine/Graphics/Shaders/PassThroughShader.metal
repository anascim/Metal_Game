//
//  Shaders.metal
//  MetalGame
//
//  Created by Alex Nascimento on 16/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn
{
    float4 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
};

struct VertexOut
{
    float4 position [[ position ]];
    float4 color;
};

struct Uniforms
{
    float4x4 modelViewProjectionMatrix;
    float xOffset;
};

vertex VertexOut vertex_function(const VertexIn vertexIn[[ stage_in ]],
                              constant Uniforms &uniforms[[buffer(1)]])
{
    VertexOut out;
    out.position = uniforms.modelViewProjectionMatrix * vertexIn.position;
    out.position[0] += uniforms.xOffset;
    out.color = vertexIn.color;
    return out;
}

fragment float4 fragment_function(VertexOut vertexIn [[stage_in]])
{
    return vertexIn.color;
}
