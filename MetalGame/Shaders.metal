//
//  Shaders.metal
//  MetalGame
//
//  Created by Alex Nascimento on 16/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex
{
    float4 position [[position]];
    float4 color;
};

struct Uniforms
{
    float4x4 modelViewProjectionMatrix;
    float xOffset;
};

vertex Vertex vertex_function(const device Vertex *vertices[[buffer(0)]],
                              constant Uniforms &uniforms[[buffer(1)]],
                              uint vid [[vertex_id]])
{
    Vertex out;
    out.position = uniforms.modelViewProjectionMatrix * vertices[vid].position;
    out.position[0] += uniforms.xOffset;
    out.color = vertices[vid].color;
    return out;
}

fragment float4 fragment_function(Vertex inVertex[[stage_in]])
{
    return inVertex.color;
}
